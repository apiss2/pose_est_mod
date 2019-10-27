
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
echo VMD-3d-pose-baseline-multi [$IDX]
echo ------------------------------------------

#  ---  python
export  P2V_ARG=-v $VERBOSE -t "$C_OUTPUT_SUB_DIR" -b "born/animasa_miku_born.csv" -c 30 -z 0 -s 1 -p 0.5 -r 3 -k 1 -e 0
docker container run --rm -v $INPUT_VIDEO_DIR:\=/:/data -it pose-test bash -c "cd /VMD-3d-pose-baseline-multi && python3 applications/pos2vmd_multi.py $P2V_ARG"

if  [ ! $ERRORLEVEL  =  0 ]; then
    exit 1
else
    echo OK
fi

exit /b 0