+++
title = 'VoxelNeXt'
date = 2024-09-03T22:23:29+02:00
authors = ['Sungsik']
categories = ['LiDAR OD']
tags = ['DeepLearning', 'PaperReview', 'LiDAR', 'ObjectDetection']
featuredImage = 'images/2024-09-03-22-26-24.png'
+++

In [Chen et. al. 2023](https://arxiv.org/abs/2303.11301) **VoxelNeXt** was introduced, which is constituted only with "sparse convolutions". The authors suggested 3D voxel-based object detection without using a dense head at it's final stage.

<!--more-->

CenterPoint uses relatively large voxel sizes, and points in each voxel are encoded by PointNet, which consists of MLPs and channel-wise max pools. The authors reduced latency by stacking pillars with points, encoding, and scattering to BEV 'dense features' again. These dense features go through a dense head and are converted to regression values. In comparison, VoxelNeXt uses smaller voxels and aggregates information with following sparse convolutions of depth, and there's no more dense feature map and dense head. It predicts objects directly through final voxels.

![](images/2024-09-04-11-11-46.png "Center Feature Missing (a.k.a CFM) - on Fan. et. al, 2022")

There was another approach utilizing sparse convolution as its backbone. FSD is one example. But it struggled with the 'center feature missing (CFM)' problem, which occurred because sparse convolutions lack aggregation ability compared to dense convolutions, and it solved CFM with center voting. They labeled features of a single object with voted centers, which are close enough to each other, and regressed the object-wise bounding boxes. This means they struggled with the small receptive field of a depth 4 CNN with sparse convolutions.

![](images/2024-09-04-11-38-59.png)

The authors of VoxelNeXt proved that this disadvantage of sparse convolution can be easily tackled with additional depth. With two more additional down-sampling layers at the end of the depth 4 CNN, F4 with stride 8, and get features F5 with stride 16 and F6 with stride 32. They combined these 3 outputs into a single image with stride 8. They showed improved receptive field using ERF, which can be easily calculated with the back-propagation method of deep learning frameworks.

To speed it up, they suggested two approaches: sparse height compression and spatially voxel pruning.

"Sparse height compression" involves compressing features according to the z-axis and getting 2D sparse features. This is reasonable for driving-scene OD because there is always a single object along the z-axis. They applied this to the "combined feature" and sent it to the detection head. They showed there is no significant change in the object detection performance.

![](images/2024-09-04-11-39-51.png)

"Spatial voxel pruning" involves dilating only a fixed portion of voxels on each layer. When stacking sparse convolutions, we do dilation first to spread the features to the output feature map. The authors reduced the number of dilated features by thresholding features using their magnitude. They showed this makes the sparse convolution CNN more efficient, without losing its advantage in performance. The idea of "Filtering voxels on layers according to their magnitude" was already suggested in another paper, and they also proved it works well without making performance worse. It's what we should be aware of when it comes to improving the latency of LiDAR OD networks.

![](images/2024-09-04-11-40-48.png)

It's noteworthy that while training they chose voxels that are near from GT, and as a result, the "seed voxels", used for regression, are not always inside the object itself. But their relative position from the object's center remains across timely-adjacent scenes, so they used the position of the query cell on object tracking, and they saw some improvement also.

![](images/2024-09-04-11-40-14.png)

And finally, they suggested a new way to do NMS, which is sparse max polling. They performed simple 3x3 max pooling for each class on predicted objects' scores. It's efficient because this operation is only applied to the voxels which are present (sparsely!) and there are not so many voxels at the final feature map.

Spatial pruning, sparse convolutions, and sparse max pooling are unconventional operations. So if you want to deploy this model, you should refer to [it's implementation](https://github.com/dvlab-research/spconv-plus). They provided it also, and look closer because their repository includes not only the suggested sparse max pool operator but also other kinds of spatially-pruned convolutions like SPSS and SPRS. These operators, SPSS and SPRS, have a smaller computational footprint but are not easily parallelizable, and as a result, they are not faster than normal sparse convolution.

## Conclusion

![](images/2024-09-04-11-38-24.png)

VoxelNeXt has its advantage in long-distance detection. Dense heads require heavy computational loads, but LiDAR data has always been sparse. They utilized the data's sparse property really well, significantly reducing both the FLOPs and latency.

![](images/2024-09-04-11-38-41.png)

Wenn it comes to the real "latency" in second, it works not as what FLOPs say. It's due to the custom operator "sparse convolution". We should build a mapping table to apply convolution "sparsely", and building a table and refering this makes parallizing hard. In other words, making this operator as a hardware, it can significantly reduce the latency. 


