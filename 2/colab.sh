#if os.path.exists("./output"):
#    rm -r ./output

# 処理日時
#now_str = "{0:%Y%m%d_%H%M%S}".format(datetime.datetime.now())
#  -- date
export  DT=$date
#  -- execute time
export  TM=$time
#  -- replace space to 0
export  TM2=$TM: =0$
#  -- use date for filename
export  DTTM=$dt:~0,4$dt:~5,2$dt:~8,2$_$TM2:~0,2$TM2:~3,2TM2:~6,2

# Googleドライブマウント
#drive.mount('/gdrive')

# 起点ディレクトリ
export base_dir="/autotrace"

export output_json="/content/output/json"
mkdir -p "$output_json"

# 出力用フォルダ
export out_dir_path=base_dir + "/" + now_str
mkdir -p "$drive_dir_path"

echo ------------------------------------------
echo Openpose
echo ------------------------------------------

# Openpose実行
cd openpose/ && ./build/examples/openpose/openpose.bin --video "$input_video" --display 0 --model_pose COCO --write_json "$output_json" --frame_first 0 --number_people_max 1

echo ------------------------------------------
echo FCRN-DepthPrediction-vmd
echo ------------------------------------------

cd FCRN-DepthPrediction-vmd && python tensorflow/predict_video.py --model_path tensorflow/data/NYU_FCRN.ckpt --video_path "$input_video" --json_path "$output_json" --interval 10 --verbose 1 --now "$now_str" --avi_output "warn"  --number_people_max 1

# 深度結果コピー
depth_dir_path =  output_json + "_" + now_str + "_depth"

cp "$depth_dir_path"/*.avi "$out_dir_path"
cp "$depth_dir_path"/message.log "$out_dir_path"
cp "$depth_dir_path"/reverse_specific.txt "$out_dir_path"
cp "$depth_dir_path"/order_specific.txt "$out_dir_path"

for i in range(1, number_people_max+1):
    echo ------------------------------------------
    echo 3d-pose-baseline-vmd ["$i"]
    echo ------------------------------------------

    target_name = "_" + now_str + "_idx0" + str(i)
    target_dir = output_json + target_name

    cd ./3d-pose-baseline-vmd && python src/openpose_3dpose_sandbox_vmd.py --camera_frame --residual --batch_norm --dropout 0.5 --max_norm --evaluateActionWise --use_sh --epochs 200 --load 4874200 --gif_fps 30 --verbose 1 --openpose "$target_dir" --person_idx 1

    echo ------------------------------------------
    echo VMD-3d-pose-baseline-multi ["$i"]
    echo ------------------------------------------

    cd ./VMD-3d-pose-baseline-multi && python applications/pos2vmd_multi.py -v 2 -t "$target_dir" -b "$born_model_csv" -c 30 -z "$center_z_scale" -s "$smooth_times" -p "$threshold_pos" -r "$threshold_rot" -k "$is_ik" -e "$heel_position"

    # INDEX別結果コピー
    idx_dir_path = out_dir_path + "/idx0" + str(i)
    mkdir -p "$idx_dir_path"

    # 日本語対策でpythonコピー
    for f in glob.glob(target_dir +"/*.vmd"):
        shutil.copy(f, idx_dir_path)

    cp "$target_dir"/pos.txt "$idx_dir_path"
    cp "$target_dir"/start_frame.txt "$idx_dir_path"