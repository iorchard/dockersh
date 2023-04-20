#!/bin/bash

if [ -z "${HOST_USER_NAME}" -o -z "${HOST_USER_ID}" -o -z "${HOST_USER_GID}" ]; then
	echo "HOST_USER_NAME, HOST_USER_ID & HOST_USER_GID needs to be set!"; exit 100
fi

groupadd --gid "${HOST_USER_GID}" "${HOST_USER_NAME}"
useradd \
      --uid ${HOST_USER_ID} \
      --gid ${HOST_USER_GID} \
      --create-home \
      --shell /bin/bash \
      ${HOST_USER_NAME}
usermod -aG sudo ${HOST_USER_NAME}

if ! grep "^${HOST_USER_NAME}" /etc/sudoers &>/dev/null; then
  echo "${HOST_USER_NAME} ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# create shared dir and symlink /data and /archive
mkdir -p /home/${HOST_USER_NAME}/shared
ln -sf /data /home/${HOME_USER_NAME}/shared/data
ln -sf /archive /home/${HOME_USER_NAME}/shared/archive

# set ownership for hot and cold data directory.
chown ${HOST_USER_ID}:${HOST_USER_GID} \
  /home/${HOST_USER_NAME}

# symlink tensorrt 8 library to 7.
ln -sf /opt/conda/lib/python3.10/site-packages/tensorrt/libnvinfer.so.8 \
  /opt/conda/lib/python3.10/site-packages/tensorrt/libnvinfer.so.7 
ln -sf /opt/conda/lib/python3.10/site-packages/tensorrt/libnvinfer_plugin.so.8 \
  /opt/conda/lib/python3.10/site-packages/tensorrt/libnvinfer_plugin.so.7

echo "I am ready."
touch /tmp/.i_am_ready

# execute jupyter
su - ${HOST_USER_NAME} -c "/opt/conda/bin/jupyter-lab --ip 0.0.0.0 --no-browser"

#exec su - "${HOST_USER_NAME}"
