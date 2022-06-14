#!/usr/bin/env python
# coding: utf-8

import torch
import torchvision
from seg_GAN import net_G
import os
from PIL import Image
import numpy as np
from pathlib import Path

data_main_path = 'E:\\MvP\\FinalExperimentWithPancreas\\Heterogenicity\\ReducePatchSize'
save_main_path = 'E:\\MvP\\FinalExperimentWithPancreas\\Heterogenicity\\ReducePatchSize\\Epi\\Mets\\'
if not os.path.exists(save_main_path):
    os.mkdir(save_main_path)
organs = ['\\']#, 'Breast', 'Esophagus', 'Pancreas']
# data_path = 'D:/German/Data/Oroph/Vanderbilt/imgs/patches2048_40x/'
# save_path = 'D:/German/Data/Oroph/Vanderbilt/masks/epi_seg2/'

seg_scale = 0.25
###Initil model
use_gpu = True  # bool
model = net_G(norm_layer=torch.nn.InstanceNorm2d)  # BatchNorm2d/InstanceNorm2d
pretrained_dict = torch.load('EP_5X.pth')
model_dict = model.state_dict()
pretrained_dict = {k: v for k, v in pretrained_dict.items() if k in model_dict}
model.load_state_dict(pretrained_dict)
model.eval()
if use_gpu:
    print(f'Running model on GPU')
    model.cuda()
print('########## Model Loaded ##########')


def tensor2im(image_tensor, imtype=np.uint8, normalize=True):
    image_numpy = image_tensor.cpu().float().numpy()
    if normalize:
        image_numpy = (np.transpose(image_numpy, (1, 2, 0)) + 1) / 2.0 * 255.0
    else:
        image_numpy = np.transpose(image_numpy, (1, 2, 0)) * 255.0
    image_numpy = np.clip(image_numpy, 0, 255)
    if image_numpy.shape[2] == 1 or image_numpy.shape[2] > 3:
        image_numpy = image_numpy[:, :, 0]
    return image_numpy.astype(imtype)


data_transform = torchvision.transforms.Compose([torchvision.transforms.ToTensor(),
                                                 torchvision.transforms.Normalize(
                                                     (0.5, 0.5, 0.5),
                                                     (0.5, 0.5, 0.5)),
                                                 ])


# for i in range(len(case_list)-1,0,-1):
for k in range(len(organs)):
    organ = organs[k]
    data_path = data_main_path+f'\\Mets256By256'
    case_list = os.listdir(data_path)
    save_path = save_main_path+organ
    if not Path(save_path).exists():
        os.mkdir(save_path)
    for i in range(len(case_list)):

        out_folder = Path(save_path +'\\'+ case_list[i])

        if not out_folder.exists():
            os.mkdir(out_folder)

        img_list = os.listdir(data_path + '\\' + case_list[i])

        for j in range(len(img_list)):

            print('Processing ' + img_list[j] + ' Img:' + str(j + 1) + '\\' + str(len(img_list)))

            out_file = save_path + '\\' + case_list[i] + '\\' + img_list[j][:-4] + '_result.png'

            if not Path(out_file).exists():
                img_name = data_path + '\\' + case_list[i] + '\\' + img_list[j]

                try:
                    Img = Image.open(img_name).convert('RGB')
                    Image_size = np.array(Img.size)
                    Img = Img.resize((Image_size * seg_scale).astype(int))
                    Img = data_transform(Img)
                    if use_gpu:
                        Img = Img.cuda()
                    with torch.no_grad():
                        output = model(Img.unsqueeze(0))
                    result_array = tensor2im(output[0, :, :, :])
                    Result = Image.fromarray(result_array)
                    Result = Result.resize(Image_size)
                    Result.save(out_file)
                except:
                    print('>>> Error processing image file')
