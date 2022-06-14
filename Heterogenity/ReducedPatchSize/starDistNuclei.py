import numpy as np
from matplotlib import pyplot as plt
import matplotlib.cm as cm
from stardist.models import StarDist2D
import glob
from stardist import random_label_cmap
from skimage.exposure import match_histograms
from tqdm import tqdm
import os
np.random.seed(6)
lbl_cmap = random_label_cmap()
# imgPath = "E:\\MvP\\StarDistTest\\*.png"
saveMainPath = "E:\\MvP\\FinalExperimentWithPancreas\\Heterogenicity\\ReducePatchSize\\Nuclei\\Mets\\"
if not os.path.exists(saveMainPath):
    os.mkdir(saveMainPath)
organs = ["Pancreas"]#, "Esophagus", "Breast"]
normalizationImg = plt.imread("E:\\MvP\\StarDistTest\\Tissue Images\\TCGA-A7-A13E-01Z-00-DX1.tif")
# underStain =plt.imread("E:\\MvP\\StarDistTest\\40 II_110593_38913.png")
# matched = match_histograms(underStain, normalizationImg, multichannel=True)
# matched = matched/255
# test plot
# fig, (ax1, ax2, ax3) = plt.subplots(nrows=1, ncols=3, figsize=(8, 3),
#                                     sharex=True, sharey=True)
# for aa in (ax1, ax2, ax3):
#     aa.set_axis_off()
# ax1.imshow(underStain)
# ax1.set_title('Source')
# ax2.imshow(normalizationImg)
# ax2.set_title('Reference')
# ax3.imshow(matched)
# ax3.set_title('Matched')
# plt.show()
# prints a list of available models
StarDist2D.from_pretrained()

# creates a pretrained model
model = StarDist2D.from_pretrained('2D_versatile_he')
for j in range(len(organs)):
    organ = organs[j]
    #imgMainPath = f"E:\\tumorSeg\\NewColon\\SplitWSI40x_patch_size_2048_{organ}Patho\\"
    imgMainPath = f"E:\\MvP\\FinalExperimentWithPancreas\\Heterogenicity\\ReducePatchSize\\Mets256By256\\"

    #print(imgMainPath)
    allImgDir = glob.glob(f"{imgMainPath}**\\*.png")
    saveMainPathWithOrgan = saveMainPath
    if not os.path.exists(saveMainPathWithOrgan):
        os.mkdir(saveMainPathWithOrgan)
    for i in tqdm(range(len(allImgDir))):#len(allImgDir)
        img = plt.imread(allImgDir[i])
        imgName = allImgDir[i].split('\\')[-1]
        WSIname = imgName.split('_')[0]
        savePath = saveMainPathWithOrgan + f"{WSIname}\\"
        if not os.path.exists(savePath):
            os.mkdir(savePath)
        saveName = savePath + imgName.replace(".png", "_bwNuc.png")
        if os.path.exists(saveName):
            continue
        matched = match_histograms(img, normalizationImg, multichannel=True)
        matched = matched / 255
        labels, details = model.predict_instances(matched)
        labels[labels > 0] = 1
        plt.imsave(saveName, labels, cmap=cm.gray)


# plt.figure(figsize=(8,8))
# plt.imshow(img)
# plt.imshow(labels, cmap=lbl_cmap, alpha=0.5)
# plt.axis('off')
# plt.show()
#
# plt.imshow(labels)
# plt.show()