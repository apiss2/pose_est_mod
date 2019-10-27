
#!/bin/bash
args="$@"

function goto
{
label=$1
cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
eval "$cmd"
exit
}

#@echo off
echo ------------------------------------------
echo FCRN-DepthPrediction-vmd
echo ------------------------------------------

#  ---  python
export  FCRN_ARG=--model_path tensorflow/data/NYU_FCRN.ckpt --video_path $C_INPUT_VIDEO --json_path $C_JSON_DIR --past_depth_path \"$PAST_DEPTH_PATH\" --interval 10 --reverse_specific \"$REVERSE_SPECIFIC_LIST\" --order_specific \"$ORDER_SPECIFIC_LIST\" --avi_output yes --verbose $VERBOSE --number_people_max $NUMBER_PEOPLE_MAX --end_frame_no $FRAME_END --now $DTTM

docker container run --rm -v $INPUT_VIDEO_DIR:\=/:/data -it pose-test bash -c "cd /FCRN-DepthPrediction-vmd/ && python3 tensorflow/predict_video.py $FCRN_ARG"

if  [ ! $ERRORLEVEL  =  0 ]; then
    exit 1
else
    echo OK
fi

exit /b 0