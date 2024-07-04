+++
title = 'PointPillars'
date = 2024-07-03T11:20:04+02:00
authors = ['Sungsik']
categories = ['LiDAR OD']
tags = ['Deep Learning', 'Paper Review']
featuredImage = 'images/2024-07-03-12-23-51.png'
+++

PointPillars is really common object detection algorithm on LiDAR domain.
NVIDIA, Intel, Matlab and TI released their own pre-trained PointPillar model and it's end-to-end inference code like below.

<!--more-->

- [NVIDIA TAO PointPillars](https://docs.nvidia.com/tao/tao-toolkit/text/point_cloud/pointpillars.html)
- [CUDA-PointPillars](https://github.com/NVIDIA-AI-IOT/CUDA-PointPillars)
- [Intel oneAPI PointPillars](https://github.com/oneapi-src/oneAPI-samples/blob/master/AI-and-Analytics/End-to-end-Workloads/LidarObjectDetection-PointPillars/README.md)
- [MATLAB PointPillars](https://de.mathworks.com/help/lidar/ug/get-started-pointpillars.html)
- [TI EdgeAI ModelZoo](https://github.com/TexasInstruments/edgeai-modelzoo/tree/main/models/vision/detection_3d)


There are two problems in LiDAR object detection domain.
The one is 'unordered' property of LiDAR point cloud, the second is the curse of dimension.
Because there is no way to order a 3D point cloud, to aggrigate information between adjacent points, you must refer every points to see if it is placed close(graph-based approch).
It takes quite a big time.
The curse of dimensionality applies to the LiDAR domain.
Fast response is an essential requirement, especially in the field of autonomous driving.
Therefore latency is a significant problem.

Lang et al. (2018) tackle the second problem, the curse of dimensionality, by voxelizing(or more precisely, pillarizing) the point cloud to transform the problem domain from 3D to 2D.
These pillars are typically 6 meters in height so they can cover all vehicles and pedestrians in normal driving situations.
For each pillar they used [PointNet](./pointnet.md), 2x ( MLP + Channelwise-ReduceMax ), to encode 3D shape of internal point cloud to descriptive features, regardless of the points' order.

<!-- ![](images/2024-07-03-12-23-51.png) -->

Before feeding the the point clouds to PointNet, the pillarized points(4 values; x, y, z, r) are enriched(augmented) with some additional information.
One is the 3D position offset relative to the arithmetic mean of all points in each pillar (+3), second is the 2D position offset relative to the pillar center (+2).
So a total 9 features('Stacked Pillars' in Figure 2) are fed to PointNet network, a.k.a PFE(pillar feature encoder), resulting in 64 features('Learned Features' in Figure 2) for each pillars.

Another trick to reduce latency is gathering(stacking) all pillars with points and passing them to PointNet.
This avoids meaningless calculation for empty pillars.
Thus the output 64 features are also in 'stacked' order, only for the pillars with points, so you should 'scatter' them to the 2D BEV space according to the "Pillar Index" in Figure 2, which was saved during the 'gathering' step.

The PFE and scatter architecture is used on several other approches like CenterPoint.

## References

Lang, A. H., Vora, S., Caesar, H., Zhou, L., Yang, J., & Beijbom, O. (2018). PointPillars: Fast Encoders for Object Detection from Point Clouds. Retrieved from https://arxiv.org/abs/1812.05784
