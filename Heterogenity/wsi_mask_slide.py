import glob
import os
import torch
from torch import nn
# from PIL import Image
from pycodelib.dataset import SlideSet, ClassSpecifiedFolder
from torchvision.models import resnext50_32x4d
from pytorch_models.models import DenseNetAlter
import matplotlib.pyplot as plt
from matplotlib import cm
import torchvision.transforms as transforms
from torch.utils.data import DataLoader
import numpy as np
import cv2
from tqdm import tqdm
from torchvision.datasets import ImageFolder
from PIL import Image
from sklearn.metrics import confusion_matrix
from sklearn.manifold import TSNE
from os.path import split
from datetime import datetime
import pickle
Image.MAX_IMAGE_PIXELS = 1000000000
print(plt)

def heatmap_overlay_rgb(img: np.ndarray, heatmap: np.ndarray):
    """
    Args:
        img:
        heatmap:
    Returns:
    """
    # noinspection PyArgumentList
    if img.dtype == np.uint8 or img.max() > 1:
        img = img.astype(np.float32)
        img /= 255.
    overlaid = heatmap + img
    max_val = np.max(overlaid)
    overlaid /= max_val
    overlaid *= 255
    overlaid = np.uint8(overlaid)
    return overlaid

def filebase(x): return os.path.splitext(os.path.basename(x))[0]


def filebase_list(which_list): return [filebase(x) for x in which_list]


wsi_thumb_root = 'E:/NMSC/CancerMask/WSI/5x/wsi5x/val'

# raw data
wsi_dir = 'S:/NMSC/WSI/annotated'
wsi_format = '*.ndpi'
mask_dir = 'E:/NMSC/CancerMask/WSI/5x/mask'
mask_format = '*.png'
export_dir = 'E:/NMSC/CancerMask/loss_20x_resnext'

output_dir = os.path.join(export_dir)
os.makedirs(output_dir, exist_ok=True)

wsi_list = glob.glob(os.path.join(wsi_dir, wsi_format))
mask_list = glob.glob(os.path.join(mask_dir, mask_format))

target_set = set(filebase_list(mask_list))
assert len(target_set) > 0
assert set(filebase_list(wsi_list)).issuperset(target_set)

# models
first_dilates = [4, 1, 1]  # [4, 1, 1]
block_configs = [(4, 4, 4, 4),
                 (4, 4, 4, 8, 8),
                 (4, 4, 4, 8, 8),
                 ]
growth_rates = [
    32,
    64,
    64
]
num_init_features_list = [
    32,
    64,
    64,
]
class_partitions = [
    [[0], [1, 2, 3]],
    [[1], [2, 3]],
    [[2], [3]]
]
# model_export_roots = 'E:/NMSC/classification/consistent_config_uncalibrate'
model_export_roots = 'E:/NMSC/classification/resnext_uncalibrate'
model_export_paths = [
    'norman_vs_cancer',  # 'E:/melanoma/new_models'
    'bcc_vs_scc',
    'situ_v_inv',
]
best_models = [
    'Cancer_Uncalibrate_best_model.pth',
    'BCC_SITU_Invasive_Uncalibrate_best_model.pth',
    'Situ_Inv_Uncalibrate_best_model.pth'
]
model_export_paths = [os.path.join(model_export_roots, x) for x in model_export_paths]
cascade_level = 0

device = torch.device("cuda:0")

# model: nn.Module = DenseNetAlter(growth_rate=growth_rates[cascade_level],
#                                 block_config=block_configs[cascade_level],
#                                 num_init_features=num_init_features_list[cascade_level],
#                                 bn_size=4, num_classes=len(class_partitions[cascade_level]), drop_rate=0.5,
#                                 first_dilate=first_dilates[cascade_level],
#                                 ).to(device)
model = resnext50_32x4d(num_classes=len(class_partitions[cascade_level]))
model = model.to(device)
gpu_ids = [0, 1]
for param in model.parameters():
    param.requires_grad_(False)
model_file = os.path.join(model_export_paths[cascade_level], best_models[cascade_level])
model.load_state_dict(torch.load(model_file)['model_dict'])
model = nn.DataParallel(model, gpu_ids)
model.eval()

batch_size = 128
target_ind = 1
softmax = nn.Softmax(dim=1)
down_level = 0
# note if dilation is already applied.
patch_size = 512
by_row = True

eval_mode = 'val'
img_transform = \
    transforms.Compose([
        transforms.ToTensor(),
    ])

class_to_idx = {
    'No Path': 0,
    'BCC': 1,
    'Situ': 2,
    'Invasive': 3,
}
dataset_wsi_thumb = ClassSpecifiedFolder(os.path.join(wsi_thumb_root), class_to_idx=class_to_idx, transforms=None)
# batch_of_1, num_worker_1. Only for Collation
dl_roi = DataLoader(dataset_wsi_thumb, pin_memory=True, shuffle=False)

thresh = 0.50  # from training
output_stat = dict()
for idx, wsi_thumb_data in enumerate(dataset_wsi_thumb):
    # Height x Width
    thumb_path = dataset_wsi_thumb.samples[idx][0]
    true_label = dataset_wsi_thumb.samples[idx][1]
    filepart = filebase(thumb_path)
    wsi_sample = os.path.join(wsi_dir, f"{filepart}.ndpi")
    print(wsi_sample)
    if not filebase(wsi_sample) in target_set:
        continue

    mask_name = os.path.join(mask_dir, f"{filepart}.png")
    mask = np.asarray(Image.open(mask_name))
    # should be in a func
    temp, _ = split(thumb_path)
    temp, class_name = split(temp)
    _, phase = split(temp)
    output_dir_phase = os.path.join(output_dir, phase, class_name)
    os.makedirs(output_dir_phase, exist_ok=True)
    output_file_name = os.path.join(output_dir_phase, f"{filepart}.png")
    # read thumbnail
    wsi_thumb = np.asarray(wsi_thumb_data['img'])
    wsi_thumb_shape = wsi_thumb.shape  # size[::-1]

    # dataset from a single WSI
    print('generate SlideSet')
    slide_dataset = SlideSet(wsi_sample, patch_size, 0, by_row, img_transform=img_transform)
    map_shape = slide_dataset.patch_map_shape
    dl_patch = DataLoader(slide_dataset, batch_size=batch_size, pin_memory=True, shuffle=False, num_workers=6)

    # infer
    batches_score_list = []
    for batch in tqdm(dl_patch):
        batch = batch.to(device)
        net_out = model(batch)
        # now 1d after slicing over column
        final_score = softmax(net_out).detach().cpu().numpy()[:, target_ind]
        batches_score_list.append(final_score)

    output_wsi: np.ndarray = np.concatenate(batches_score_list)
    output_wsi = np.reshape(output_wsi, map_shape)
    # cv2 resize as fx and fy
    output_map = cv2.resize(output_wsi, (wsi_thumb_shape[1], wsi_thumb_shape[0]), interpolation=cv2.INTER_NEAREST)
    mask_target = cv2.resize(mask, (output_wsi.shape[1], output_wsi.shape[0]), interpolation=cv2.INTER_AREA) / 255.
    mask_target = (mask_target > 0.3) * 1.0
    heatmap = cm.coolwarm(output_map)[:, :, 0:3]

    # roi_origin = roi  # 0.5 * (roi + 1.0)
    wsi_array = np.asarray(wsi_thumb)

    final_output_overlay = heatmap_overlay_rgb(wsi_array, heatmap)
    cv2.imwrite(output_file_name, cv2.cvtColor(final_output_overlay, cv2.COLOR_BGR2RGB))
    conf_mat = confusion_matrix(mask_target.ravel().astype(np.int), output_wsi.ravel() >= thresh)
    output_stat[filepart] = (phase, conf_mat, mask, mask_target, output_wsi, true_label)
    print(conf_mat)

time_tag = str(datetime.now().strftime("%Y_%d_%m %H_%M_%S"))
output_pickle_name = f"resnext_stats_{time_tag}.pickle"
pickle_dir = os.path.join(export_dir, output_pickle_name)
with open(pickle_dir, 'wb') as root:
    pickle.dump(output_stat, root)

stat_list = list(output_stat.values())
conf_list = [x[1] for x in stat_list]

accum_conf = sum(conf_list)
norm_accum = accum_conf / accum_conf.sum(axis=1, keepdims=True)

avg_conf_list = [conf_mat / conf_mat.sum(axis=1, keepdims=True) for conf_mat in conf_list]