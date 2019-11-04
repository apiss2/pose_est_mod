import datetime
from os.path import dirname, join, basename

from tf_pose_estimation.tf_pose import pose_estimation
from FCRN_DepthPrediction_vmd.depth_pred import depth_pred
from d3_pose_baseline_vmd.src.d3pose_vmd import baseline

def video2vmd(input_video_path):
    now_str = "{0:%Y%m%d_%H%M%S}".format(datetime.datetime.now())
    now_dir = dirname(__file__)
    json_dir = join(now_dir, "json")
    depth_path = '{0}/{1}_{2}_depth'.format(dirname(json_dir), basename(json_dir), now_str)
    person_path = '{0}/{1}_{2}_idx01'.format(dirname(json_dir), basename(json_dir), now_str)

    pose_estimation(input_video_path, json_dir)
    depth_pred(now_str, input_video_path, json_dir)
    baseline(now_str)
    #vmd_pose_baseline

