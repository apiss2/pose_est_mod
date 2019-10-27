FROM tensorflow/tensorflow:1.8.0-gpu-py3

WORKDIR "/"

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONIOENCODING=utf-8

# Openpose version
ARG ver_openpose="v1.5.0"

# trace_kit version
ARG ver_tag="ver1.02.01"

# install packages
RUN apt-get update -y --fix-missing
RUN apt-get install -y wget

RUN wget -c "https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz"
RUN tar xf cmake-3.13.4.tar.gz
RUN cd cmake-3.13.4 && ./configure && make && make install

# Basic
RUN apt-get --assume-yes update
RUN apt-get --assume-yes install build-essential
# OpenCV
RUN apt-get --assume-yes install libopencv-dev
# General dependencies
RUN apt-get --assume-yes install libatlas-base-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler
RUN apt-get --assume-yes install --no-install-recommends libboost-all-dev
# Remaining dependencies, 14.04
RUN apt-get --assume-yes install libgflags-dev libgoogle-glog-dev liblmdb-dev
# Python3 libs
RUN apt-get --assume-yes install python3-setuptools python3-dev build-essential
RUN apt-get --assume-yes install python3-pip
RUN pip3 install --upgrade numpy protobuf opencv-python
# OpenCL Generic
RUN apt-get --assume-yes install opencl-headers ocl-icd-opencl-dev
RUN apt-get --assume-yes install libviennacl-dev

# Openpose
#RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git --depth 1 -b 1.5.0
RUN curl -L -O https://github.com/CMU-Perceptual-Computing-Lab/openpose/archive/v1.5.0.zip
RUN apt install -y unzip
RUN unzip v1.5.0.zip && rm v1.5.0.zip
RUN mv openpose-1.5.0 openpose
RUN cd openpose/models && ./getModels.sh

RUN sed -i 's/execute_process(COMMAND git checkout master WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}\/3rdparty\/caffe)/execute_process(COMMAND git checkout f019d0dfe86f49d1140961f8c7dec22130c83154 WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}\/3rdparty\/caffe)/g' openpose/CMakeLists.txt
RUN cd openpose && rm -r build || true
RUN mkdir /openpose/build && cd /openpose/build && cmake ..
RUN cd /openpose && make -j 'nproc'

# FCRN-DepthPrediction-vmd
#RUN git clone  --depth 1 -b ${ver_tag} https://github.com/miu200521358/FCRN-DepthPrediction-vmd.git
RUN curl -L -O https://github.com/miu200521358/FCRN-DepthPrediction-vmd/archive/master.zip
RUN unzip master.zip && rm master.zip
RUN mkdir -p ./FCRN-DepthPrediction-vmd/tensorflow/data
RUN cd  ./FCRN-DepthPrediction-vmd/tensorflow/data
RUN wget -c "http://campar.in.tum.de/files/rupprecht/depthpred/NYU_FCRN-checkpoint.zip"
RUN unzip NYU_FCRN-checkpoint.zip && rm NYU_FCRN-checkpoint.zip

# 3d-pose-baseline-vmd の clone
#RUN git clone  --depth 1 -b "$ver_tag" https://github.com/miu200521358/3d-pose-baseline-vmd.git
RUN curl -L -O https://github.com/miu200521358/3d-pose-baseline-vmd/archive/master.zip
RUN unzip master.zip && rm master.zip
RUN mkdir -p ./3d-pose-baseline-vmd/data
RUN cd  ./3d-pose-baseline-vmd/data && wget -c "https://www.dropbox.com/s/e35qv3n6zlkouki/h36m.zip"
RUN unzip h36m.zip && rm h36m.zip

RUN mkdir -p ./3d-pose-baseline-vmd/experiments

ARG file_id="1v7ccpms3ZR8ExWWwVfcSpjMsGscDYH7_"
ARG file_name="experiments.zip"
RUN cd  ./3d-pose-baseline-vmd && curl -sc ./cookie "https://drive.google.com/uc?export=download&id=$file_id" > /dev/null
ARG code="$(awk '/_warning_/ {print $NF}' ./cookie)"
RUN cd  ./3d-pose-baseline-vmd && curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=$code&id=$file_id" -o "$file_name"
RUN cd  ./3d-pose-baseline-vmd && unzip experiments.zip && rm experiments.zip

# VMD-3d-pose-baseline-multi の clone

RUN git clone  --depth 1 -b "$ver_tag" https://github.com/miu200521358/VMD-3d-pose-baseline-multi.git
RUN apt-get install python3-pyqt5
RUN apt-get install pyqt5-dev-tools
RUN apt-get install qttools5-dev-tools


CMD ["bash"]

