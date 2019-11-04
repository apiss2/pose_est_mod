export  INPUT_VIDEO="/home/input.mp4"

for i in $INPUT_VIDEO;
do
    INPUT_VIDEO_DIR=$(dirname $i)
    INPUT_VIDEO_FILENAME=$(basename $i)
    INPUT_VIDEO_FILENAME_EXT=${INPUT_VIDEO_FILENAME%.*}
    echo $INPUT_VIDEO_FILENAME_EXT
done