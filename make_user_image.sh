#!/bin/bash

if [ -z "$1" -o -z "$2" ]; then
	echo "./make_user_image.sh [name] [source-image]"; exit 100
fi

sed "s#^FROM .*#FROM $2#" image_template/Dockerfile > image_template/Dockerfile.$1
pushd image_template
  docker build -t $1 -f Dockerfile.$1 .
popd
