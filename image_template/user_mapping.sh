#!/bin/bash

if [ -z "${HOST_USER_NAME}" -o -z "${HOST_USER_ID}" -o -z "${HOST_USER_GID}" ]; then
	echo "HOST_USER_NAME, HOST_USER_ID & HOST_USER_GID needs to be set!"; exit 100
fi

useradd \
      --uid ${HOST_USER_ID} \
      --gid ${HOST_USER_GID} \
      --create-home \
      --shell /bin/bash \
      ${HOST_USER_NAME}
groupadd --gid "${HOST_USER_GID}" "${HOST_USER_NAME}"
usermod -aG sudo ${HOST_USER_NAME}

if ! grep "^${HOST_USER_NAME} ALL" /etc/sudoers; then
  echo "${HOST_USER_NAME}	ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# set ownership for hot and cold data directory.
chown ${HOST_USER_ID}:${HOST_USER_GID} \
  /home/${HOST_USER_NAME}/{hot,cold}data


exec su - "${HOST_USER_NAME}"
