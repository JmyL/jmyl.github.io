+++
title = "You can't manage what you can't measure"
date = 2024-07-06T23:17:26+02:00
authors = ['Sungsik']
categories = ['Dev Philosophy']
tags = ['Tech Lead', 'Test']
featuredImage = 'images/ruler.jpg'
+++

It might sound boring for most engineers, 
but I have personally encountered some individuals who do not prioritize measurement, even if they lead a group of engineers.
<!--more-->
Through this experience, I realized that the value of measurement is not the same for everyone, nor is it their priority.


We can argue on this topic, but one thing is true:
if you can't measure something, it is hard to tell if it's improving or worsening.
With a ruler, as in the above image, we can say a point is on a bigger tick and the other stands on a lower tick.
The ruler plays a role in measurement.

Surely, there are many factors in the world which can't be easily measured.
The more precious something is, the harder it is to measure.
But at least while we are doing engineering, we should focus on what we want to improve, and then we MUST find a way to quantify it.

This is also the way of managing manufacturing.
The current status of Samsung or their revenue is not todays topic.
However, you know, Samsung is one of the greatest manufacturing companies in the world.
They know their job.
This relies on their product verification (PV) step.
In the PV phase, the "reliability group" calls the shot.
There are so many constraints on every aspect of the product, and almost everything is numerically constrained.
If it is hard to measure, they design a new tester and use it to measure that aspect.

When I worked at MELFAS and we developed and provided touchscreen to Samsung.
But we also made test machines measuring touchscreen's sensitivity and accuracy and sold them.
It had multiple metal rods to emulate human fingers.
By touching one of them on a screen, we measured mean and maximum jitter of position/area.
These numerical values represented the touchscreen's performance, so they saved the original data for 100 touchscreens and repeated the test after exposing them to heat and humidity.
Because the Samsung reliability group took charge of making test machines and setting up test specifications, they appreciated that we prepared everything for them.
Having friends in the PV group improved our relationship with Samsung's developers because they needed to satisfy the reliability group to pass the PV step.
Measurement was the key to this.

When I led a team to develop a golf simulator which can calculate the rotation from sequence of golf ball images, we faced challenge.
We had no equipment that could rotate a ball with a target rotation.
I suggested building a ball as a simulation model and using it while developing the algorithm.
Providing precise measurements became a playground for collages.
My collage, who studied mathematics, discovered great solution.

Object detection with LiDAR is not special in this regard.
Detection performance should be measured.
Every object detection papers does this with mAP.
mAP is the area under the AP curve, which pairs precision and recall according to several confidence scores (normally finding confidence score thresholds for several fixed recall values at equal distances), but the precision and recall depend on an IoU threshold.
If you do this process with a high IoU threshold, you will get a good measurement which represents reality well.
But Waymo suggests calculating mAP with IoU threshold 0.7 for vehicles, 0.5 for pedestrians and cyclists, but those threshold are not big enough.
You will be surprised when you see how different they are with IoU 0.7 or 0.5.
This is because most networks perform poorly with a strict constraint like 0.9.
So if you want to improve your network's bounding box prediction, you should calculate mAP with high IoU, at least 0.85 in my opinion.
If it doesn't make sense, find a reasonable BEV range and do it again.
I drew a histogram of IoU for the pairs of ground truths and predictions.
This could also be a good way to compare network performance.
