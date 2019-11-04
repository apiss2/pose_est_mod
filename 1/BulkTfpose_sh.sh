
#!/bin/bash
args=$@

#  --- input_movie_path
echo full_path of your movie
echo human must be in frame no.1
export  INPUT_VIDEO="/home/input.mp4"
#read -p ": " INPUT_VIDEO

#  ---  The frame no. of beginning

export  FRAME_FIRST=0
export  NUMBER_PEOPLE_MAX=1
export  FRAME_END=-1
export  VERBOSE=2
export  IS_DEBUG=warn
#  ??????????????????????
export  REVERSE_SPECIFIC_LIST=[]
export  ORDER_SPECIFIC_LIST=[]

if  [ "$IS_DEBUG" = "yes" ]; then
    export  VERBOSE=3
else
    echo fault
fi

if  [ "$IS_DEBUG" = "warn" ]; then
    export  VERBOSE=1
else
    echo fault
fi

#  --echo NUMBER_PEOPLE_MAX: %NUMBER_PEOPLE_MAX%

#  -----------------------------------
export  INPUT_VIDEO_DIR=$(dirname $INPUT_VIDEO)
export  INPUT_VIDEO_FILENAME=$(basename $INPUT_VIDEO)
export  INPUT_VIDEO_FILENAME_EXT=${INPUT_VIDEO_FILENAME%.*}

#  -- date
export  DT=$date
#  -- time
export  TM=$time
#  -- replace space to 0
export  TM2=$TM: =0$
#  -- use date for filename
export  DTTM=$dt:~0,4$dt:~5,2$dt:~8,2$_$TM2:~0,2$TM2:~3,2TM2:~6,2

echo --------------

#  ------------------------------------------------
#  -- JSON output dir
export  OUTPUT_JSON_DIR=$INPUT_VIDEO_DIR$INPUT_VIDEO_FILENAME$_$DTTM$\INPUT_VIDEO_FILENAME_json
#  echo %OUTPUT_JSON_DIR%

mkdir $OUTPUT_JSON_DIR
echo result_JSON_dir???$OUTPUT_JSON_DIR


echo --------------
echo start tf-pose-estimation
echo --------------

#  -- execute
export  C_INPUT_VIDEO=/data/$INPUT_VIDEO_FILENAME_EXT
export  C_JSON_DIR=/data/$INPUT_VIDEO_FILENAME$_$DTTM$/INPUT_VIDEO_FILENAME_json
export  C_OUTPUT_VIDEO=/data/$INPUT_VIDEO_FILENAME$_$DTTM$/INPUT_VIDEO_FILENAME_openpose.avi
export  TFPOSE_ARG=--video $C_INPUT_VIDEO --model mobilenet_v2_large --write_json $C_JSON_DIR --write_video $C_OUTPUT_VIDEO --number_people_max $NUMBER_PEOPLE_MAX --frame_first $FRAME_FIRST --no_display
docker container run --rm -v $INPUT_VIDEO_DIR:\=/:/data -it pose-test bash -c "cd /tf-pose-estimation && python3 run_video.py $TFPOSE_ARG"

if  [ ! $ERRORLEVEL  =  0 ]; then
    exit 1
else
    echo OK
fi

echo --------------
echo Done!!

exit /b 0