#!/bin/bash

IMG_NAME=${1:-kymeka}
BASE_IMAGE=${2:-pytorch/pytorch:1.13.1-cuda11.6-cudnn8-runtime}
TF_VER="2.11.0"

sed "s#^FROM .*#FROM ${BASE_IMAGE}#" images/Dockerfile > images/Dockerfile.${IMG_NAME}
pushd images
  docker build -t ${IMG_NAME} \
    --build-arg TF_VER=${TF_VER} \
    -f Dockerfile.${IMG_NAME} .
popd
