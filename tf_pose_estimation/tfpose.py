import argparse
import logging
import time

import cv2
import numpy as np
import os
import sys

from .tf_pose.estimator import TfPoseEstimator
from .tf_pose.networks import get_graph_path, model_wh

def str2bool(v):
    return v.lower() in ("yes", "true", "t", "1")

def pose_estimation(input_video_path, output_json_dir):
    model = 'mobilenet_thin' #'cmu / mobilenet_thin / mobilenet_v2_large / mobilenet_v2_small'

    w, h = model_wh('432x368')
    e = TfPoseEstimator(get_graph_path(model), target_size=(w, h), trt_bool=False)
    cap = cv2.VideoCapture(input_video_path)

    if cap.isOpened() is False:
        sys.exit(1)

    sys.stdout.write("frame: ")
    frame = 0
    detected = False
    while cap.isOpened():
        ret_val, image = cap.read()
        if not ret_val:
            break

        sys.stdout.write('\rframe: {:5}'.format(frame))
        humans = e.inference(image, resize_to_default=(w > 0 and h > 0), upsample_size=4.0)
        if len(humans) > 0:
            detected = True
        del humans[1:]
        image = np.zeros(image.shape)
        image = TfPoseEstimator.draw_humans(image, humans, imgcopy=False, frame=frame, output_json_dir=output_json_dir)
        frame += 1

        if cv2.waitKey(1) == 27:
            break

    sys.stdout.write("\n")

    if not detected:
        sys.exit(1)


