import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
#from sklearn.manifold import TSNE as tsne
import matplotlib as mpl
import umap
import os
import scipy.io as sio
mpl.use('TkAgg')
nComponents = 3
organs = ['Colon', 'Esophagus',
          'Breast']  # , 'Pancreas']
list_subfolders_with_paths = [f.path for f in os.scandir('E:\\MvP\\FinalExperimentWithPancreas\\NormalizedData\\Test\\')
                              if f.is_dir()]
method = 'wilcoxon'
minDist = 0.2
n_neighbors = 20
featIdxPath = f'E:\\MvP\\FinalExperimentWithPancreas\\ModelTraining\\ModelTrained\\topFeats_{method}.xlsx'
featTable = pd.read_excel(featIdxPath, 'AllFeatsIdx')
featIdx = featTable['Colon']-1 # From matlab to python indexing
metStatus = pd.read_excel('E:\\MvP\\FinalExperimentWithPancreas\\PatchSelectedWithPancreas\\metStatus.xlsx', header=None)
testIdx = sio.loadmat('E:\\MvP\\FinalExperimentWithPancreas\\PatchSelectedWithPancreas\\testIdx.mat')
testIdx = np.asarray(testIdx['testIdx'].tolist()).squeeze()
testIdx = testIdx-1# From matlab to python indexing
caseID = pd.read_excel('E:\\MvP\\FinalExperimentWithPancreas\\PatchSelectedWithPancreas\\caseID.xlsx', header=None)
y_s = metStatus[0][testIdx]
breastStatus = pd.read_excel('E:\\MvP\\Breast ER-PR-HER2.xlsx')
# breastStatus['Unnamed: 0']
testCase = caseID[0][testIdx.tolist()]
breastOrnot = y_s.str.contains('Breast', regex=False).to_numpy()
testCase = testCase[breastOrnot]
testCase[10] = '27M'
testCase[27] = '74M'
intersection = np.intersect1d(breastStatus['Unnamed: 0'],testCase, return_indices=True)
breastStatusIndex = intersection[1]
y_sHER2 = metStatus[0][testIdx].reset_index(drop=True)
y_sHER2[breastOrnot] = breastStatus['HER2'][intersection[1]].reset_index(drop=True)
y_sER = metStatus[0][testIdx].reset_index(drop=True)
y_sER[breastOrnot] = breastStatus['ER'][intersection[1]].reset_index(drop=True)
y_sPR = metStatus[0][testIdx].reset_index(drop=True)
y_sPR[breastOrnot] = breastStatus['PR'][intersection[1]].reset_index(drop=True)

for j in range(1):
    mainPath = list_subfolders_with_paths[j] + '\\'
    dd = pd.read_excel(mainPath + 'featuresCombined_normalized.xlsx',
                       0, header=None)
    dd = dd.to_numpy()
    dvv = dd[featIdx, :]
    reducer = umap.UMAP(random_state=42, n_components=nComponents, min_dist=minDist, n_neighbors=n_neighbors)
    reducer2D = umap.UMAP(random_state=42, n_components=2, min_dist=minDist, n_neighbors=n_neighbors)
    target_ids = ["Colon", "Esophagus", "Breast", "Pancreas"]
    target_idsER = ["Colon", "Esophagus", "ER+", "ER-", "Pancreas"]
    target_idsPR = ["Colon", "Esophagus", "PR+", "PR-", "Pancreas"]
    target_idsHER2 = ["Colon", "Esophagus", "HER2+", "HER2-", "Pancreas"]
    dr = reducer.fit_transform(np.transpose(dvv))

    dr2d = reducer2D.fit_transform(np.transpose(dvv))
    # colors = 'r', 'pink', 'b', 'c', 'g', 'lime', 'orange', 'wheat'
    colors = 'r', 'b', 'g', 'g', 'orange'
    colorsRaw = 'r', 'b', 'g', 'orange'
    shapes = 'o', 'o', 'o', 'o'
    shapesMolecular = 'o', 'o', '+', '_', 'o'
    fig = plt.figure()
    for i, c, label, shape in zip(target_ids, colorsRaw, target_ids, shapes):
        criteria = y_s.str.contains(i).to_numpy()
        # plt.scatter(dr[criteria, 0], dr[criteria, 1], c=c, label=label, marker=shape)
        plt.scatter(dr2d[criteria, 0], dr2d[criteria, 1], c=c, label=label, marker=shape)
    frame1 = plt.gca()
    frame1.axes.xaxis.set_ticklabels([])
    frame1.axes.yaxis.set_ticklabels([])
    plt.title("Raw-2D")
    plt.show()
    fig = plt.figure()
    for i, c, label, shape in zip(target_idsER, colors, target_idsER, shapesMolecular):
        criteria = np.char.find(y_sER.to_numpy().astype(str), i) == 0
        # plt.scatter(dr[criteria, 0], dr[criteria, 1], c=c, label=label, marker=shape)
        plt.scatter(dr2d[criteria, 0], dr2d[criteria, 1], c=c, label=label, marker=shape)
    frame1 = plt.gca()
    frame1.axes.xaxis.set_ticklabels([])
    frame1.axes.yaxis.set_ticklabels([])
    plt.title("ER")
    plt.show()
    fig = plt.figure()
    for i, c, label, shape in zip(target_idsPR, colors, target_idsPR, shapesMolecular):
        criteria = np.char.find(y_sPR.to_numpy().astype(str), i) == 0
        # plt.scatter(dr[criteria, 0], dr[criteria, 1], c=c, label=label, marker=shape)
        plt.scatter(dr2d[criteria, 0], dr2d[criteria, 1], c=c, label=label, marker=shape)
    frame1 = plt.gca()
    frame1.axes.xaxis.set_ticklabels([])
    frame1.axes.yaxis.set_ticklabels([])
    plt.title("PR")
    plt.show()
    fig = plt.figure()
    for i, c, label, shape in zip(target_idsHER2, colors, target_idsHER2, shapesMolecular):
        criteria = np.char.find(y_sHER2.to_numpy().astype(str), i) == 0
        # plt.scatter(dr[criteria, 0], dr[criteria, 1], c=c, label=label, marker=shape)
        plt.scatter(dr2d[criteria, 0], dr2d[criteria, 1], c=c, label=label, marker=shape)
    frame1 = plt.gca()
    frame1.axes.xaxis.set_ticklabels([])
    frame1.axes.yaxis.set_ticklabels([])
    plt.title("HER2")
    plt.show()

    #tsneEmbed = tsne(n_components=nComponents).fit_transform(np.transpose(dvv))
    # fig = plt.figure()
    # ax = fig.add_subplot(111, projection='3d')
    #
    #
    #
    # for i, c, label, shape in zip(target_ids, colorsRaw, target_ids, shapes):
    #     criteria = y_s.str.contains(i).to_numpy()
    #     # plt.scatter(dr[criteria, 0], dr[criteria, 1], c=c, label=label, marker=shape)
    #     ax.scatter(dr[criteria, 0], dr[criteria, 1], dr[criteria, 2], c=c, label=label, marker=shape)
    # plt.legend()
    # plt.title("Raw")
    # frame1 = plt.gca()
    # frame1.axes.xaxis.set_ticklabels([])
    # frame1.axes.yaxis.set_ticklabels([])
    # frame1.axes.zaxis.set_ticklabels([])
    # plt.show()
    #
    # fig = plt.figure()
    # ax = fig.add_subplot(111, projection='3d')
    # for i, c, label, shape in zip(target_idsER, colors, target_idsER, shapesMolecular):
    #     criteria = np.char.find(y_sER.to_numpy().astype(str), i) == 0
    #     # criteria = y_sER.str.contains(i).to_numpy()
    #     # plt.scatter(dr[criteria, 0], dr[criteria, 1], c=c, label=label, marker=shape)
    #     ax.scatter(dr[criteria, 0], dr[criteria, 1], dr[criteria, 2],
    #                c=c, label=label, marker=shape)
    # plt.legend()
    # plt.title("ER")
    # frame1 = plt.gca()
    # frame1.axes.xaxis.set_ticklabels([])
    # frame1.axes.yaxis.set_ticklabels([])
    # frame1.axes.zaxis.set_ticklabels([])
    # plt.show()
    #
    # fig = plt.figure()
    # ax = fig.add_subplot(111, projection='3d')
    # for i, c, label, shape in zip(target_idsPR, colors, target_idsPR, shapesMolecular):
    #     criteria = np.char.find(y_sPR.to_numpy().astype(str), i) == 0
    #     # criteria = y_sPR.str.contains(i).to_numpy()
    #     # plt.scatter(dr[criteria, 0], dr[criteria, 1], c=c, label=label, marker=shape)
    #     ax.scatter(dr[criteria, 0], dr[criteria, 1], dr[criteria, 2],
    #                c=c, label=label, marker=shape)
    # plt.legend()
    # plt.title("PR")
    # frame1 = plt.gca()
    # frame1.axes.xaxis.set_ticklabels([])
    # frame1.axes.yaxis.set_ticklabels([])
    # frame1.axes.zaxis.set_ticklabels([])
    # plt.show()
    #
    # fig = plt.figure()
    # ax = fig.add_subplot(111, projection='3d')
    # for i, c, label, shape in zip(target_idsHER2, colors, target_idsHER2, shapesMolecular):
    #     criteria = np.char.find(y_sHER2.to_numpy().astype(str), i) == 0
    #     # criteria = y_sHER2.str.contains(i).to_numpy()
    #     # plt.scatter(dr[criteria, 0], dr[criteria, 1], c=c, label=label, marker=shape)
    #     ax.scatter(dr[criteria, 0], dr[criteria, 1], dr[criteria, 2],
    #                c=c, label=label, marker=shape)
    # plt.legend()
    # plt.title("HER2")
    # frame1 = plt.gca()
    # frame1.axes.xaxis.set_ticklabels([])
    # frame1.axes.yaxis.set_ticklabels([])
    # frame1.axes.zaxis.set_ticklabels([])
    # plt.show()
    #
    #



    # fig = plt.figure()
    # ax = fig.add_subplot(111, projection='3d')
    # for i, c, label, shape in zip(target_ids, colors, target_ids, shapes):
    #     criteria = y_s.str.contains(i).to_numpy()
    #     # plt.scatter(dr[criteria, 0], dr[criteria, 1], c=c, label=label, marker=shape)
    #     ax.scatter(tsneEmbed[criteria, 0], tsneEmbed[criteria, 1], tsneEmbed[criteria, 2],
    #                c=c, label=label, marker=shape)
    # plt.legend()
    # plt.show()
    sio.savemat('umap_Embedded.mat', {'UMAP':dr})
