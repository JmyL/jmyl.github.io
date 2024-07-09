+++
title = 'PointNet'
date = 2024-07-04T08:12:05+02:00
authors = ['Sungsik']
categories = ['LiDAR OD']
tags = ['DeepLearning', 'PaperReview', 'LiDAR', 'ObjectDetection']
featuredImage = 'images/2024-07-04-08-13-17.png'
+++

PointNet represents a significant leap forward in the field of LiDAR object detection.
The authors utilized only associative operators such as channel-wise MLPs and point-wise max pooling to stabilize the results, making them invariant to the order of the points.
In PointNet, MLPs play a role in enriching features by increasing the dimension of each tensor from 3 (since the input is 3D points) to N.
The max pooling then takes these enriched features and reduces them using the max operator, resulting in a single tensor with dimension N, regardless of the number of points.
The authors have demonstrated that this network can represent the outer bounds of any complex but continuous 3D structure with a sufficiently large N.
Impressive, isn't it?

The most intriguing interpretation of this number N is its role as "critical points" that summarize the shape.
Determining the critical points is straightforward:
if you remove a point from the point cloud and feed the remaining points into the trained PointNet, and the result remains the same, that point is not critical.
The MLPs rotate and bend space through N transformations, and the max pool captures the extreme(maximum) values.
Through these operations, all critical points are retained and used as input tensors for classification or segmentation networks.
The authors conducted an interesting experiment where they fed the trained PointNet testing points within an edge-length-2 cube to see if these were all smaller than the output tensor with the original point cloud.
If so, those points are included in its upper bound shape.


![](images/2024-07-04-16-35-13.png)

## What you can ignore when you came from [PointPillars]({{< ref pointpillars.md >}})

A network using convolution shows good generalization ability to affine transformations, but MLPs and max pooling do not have this capability.
Consequently, the authors had no means to classify objects that were shifted or rotated via affine transformations.
To address this, they inserted a T-Net and a matrix multiplication step before the first MLP as an affine transformation block.
The T-Net itself is a small PointNet with an MLP, a max pool, and a fully connected layer to predict a suitable transformation matrix that aligns the input point cloud to a 'canonical' rotation.
They divided the MLP into two blocks and added a 'feature transform' block, which is identical to the first T-Net and matrix multiplication, to generalize the network.
They designed a loss function to restrict the resulting 64x64 transformation matrix to be orthogonal, which plays a positive role in optimizing this complex transformation.
[PointPillars]({{< ref pointpillars.md >}}) uses PointNet as the point cloud encoder for each pillar.
Since every point needs to "be represented without such a transformation", we don't need T-Net on voxelization process.
The following convlutional network will do his job.

There are segmentation networks that use the tile operation to broadcast aggregated global features (the output features of the last MLP in the encoder) to the local features (geometry).
This type of feature aggregation is applied to the PFE in PointPillars, not for segmentation, but to enrich features.

