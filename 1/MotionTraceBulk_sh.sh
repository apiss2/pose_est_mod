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
cls

#  docker image tag
export  IMAGE_TAG=1.02.01-3

#  -- tf-pose-estimation
/sh/BulkTfpose_sh.sh

echo BULK OUTPUT_JSON_DIR: $OUTPUT_JSON_DIR


#  -----------------------------------
#  --- JSON_output_subdir
for 1 in $OUTPUT_JSON_DIR
do
(
done

    export  OUTPUT_JSON_DIR_PARENT=$~dp1
    export  OUTPUT_JSON_DIR_NAME=$~n1
)

export  PARENT_DIR_FULL=$OUTPUT_JSON_DIR_PARENT:~0,-1
for i in $PARENT_DIR_FULL
do
(
done

    export  PARENT_DIR_NAME=$~ni
)

#  -- date
export  DT=$date
#  -- execute ime
export  TM=$time
#  -- replace space to 0
export  TM2=$TM: =0$
#  -- use date for filename
export  DTTM=$dt:~0,4$dt:~5,2$dt:~8,2$_$TM2:~0,2$TM2:~3,2TM2:~6,2

#  -- FCRN-DepthPrediction-vmd
/sh/BulkDepth_sh.sh

#  -- loop for capture num
for /L $i in (1,1,$NUMBER_PEOPLE_MAX) do (
    export  IDX=$i

    #  -- 3d-pose-baseline
    /sh/Bulk3dPoseBaseline_sh.sh

    #  -- 3dpose_gan
    #  call Bulk3dPoseGan_Docker.bat

    #  -- VMD-3d-pose-baseline-multi
    /sh/BulkVmd_sh.sh
)

echo ------------------------------------------
echo trace result
echo json: $OUTPUT_JSON_DIR
echo vmd:  $OUTPUT_SUB_DIR
echo ------------------------------------------