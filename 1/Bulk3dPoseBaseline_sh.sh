
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

#  -- index
export  DISPLAY_IDX=0$IDX

#  echo OUTPUT_JSON_DIR_PARENT: %OUTPUT_JSON_DIR_PARENT%
#  echo OUTPUT_JSON_DIR_NAME: %OUTPUT_JSON_DIR_NAME%
#  echo DISPLAY_IDX: %DISPLAY_IDX%

#  ------------------------------------------------
export  OUTPUT_SUB_DIR=$OUTPUT_JSON_DIR_PARENT$\$OUTPUT_JSON_DIR_NAME$_$DTTM$_idxDISPLAY_IDX

#  echo OUTPUT_SUB_DIR: %OUTPUT_SUB_DIR%

echo ------------------------------------------
echo 3d-pose-baseline-vmd [$IDX]
echo ------------------------------------------

#  ---  python
export  C_OUTPUT_SUB_DIR=/data/$PARENT_DIR_NAME$/$OUTPUT_JSON_DIR_NAME$_$DTTM$_idxDISPLAY_IDX
export  BL_ARG=--camera_frame --residual --batch_norm --dropout 0.5 --max_norm --evaluateActionWise --use_sh --epochs 200 --load 4874200 --gif_fps 30 --verbose $VERBOSE --openpose $C_OUTPUT_SUB_DIR --person_idx 1
docker container run --rm -v $INPUT_VIDEO_DIR:\=/:/data -it pose-test bash -c "cd /3d-pose-baseline-vmd && python3 src/openpose_3dpose_sandbox_vmd.py $BL_ARG"

if  [ ! $ERRORLEVEL  =  0 ]; then
    exit 1
else
    echo OK
fi

exit /b 0