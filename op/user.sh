#!/bin/bash

HOMEPATH="/data"
ARCHIVEPATH="/archive"

function _check() {
  if [ -z "${USER}" ]; then
    echo "Error) USER is empty."
    exit 1
  fi
}
function adduser() {
  _check
  # pw_name:pw_passwd:pw_uid:pw_gid:pw_gecos:pw_dir:pw_shell
  PASS=$(head /dev/urandom |tr -dc A-Za-z0-9 |head -c 12)
  echo "${PASS}" | pass insert -m --force kymeka/${USER}
  ENTRY="${USER}:${PASS}::${GRP}::${HOMEPATH}/${USER}:/usr/local/bin/dockersh"
  echo ${ENTRY} | sudo newusers
   
  sudo adduser ${USER} docker
  sudo chage --lastday 0 ${USER}
  sudo mkdir -p \
  	${HOMEPATH}/${USER}/containerhome/hot \
  	${ARCHIVEPATH}/${USER}/cold
  sudo chown -R ${USER}:${GRP} \
  	${HOMEPATH}/${USER} \
  	${ARCHIVEPATH}/${USER}
}
function deluser() {
  _check
  sudo deluser --remove-home ${USER}
}
function USAGE() {
  echo "USAGE: $0 [-h|-e|-i|-d] <username>" 1>&2
  echo
  echo " -h --help                   Display this help message."
  echo " -e --external               User type is external."
  echo " -i --internal               User type is internal."
  echo " -d --delete                 Delete user."
  echo
}

if [ $# -lt 1 ]; then
  USAGE
  exit 1
fi
OPT=$1
shift
USER=$1
while true
do
  case "$OPT" in
    -h | --help)
      USAGE
      exit 0
      ;;
    -e | --external)
      HOMEPATH="/data/external"
      ARCHIVEPATH="/archive/external"
      GRP="external"
      adduser
      break
      ;;
    -i | --internal)
      GRP="internal"
      adduser
      break
      ;;
    -d | --delete)
      deluser
      break
      ;;
    *)
      echo Error: unknown option: "$OPT" 1>&2
      echo " "
      USAGE
      exit 1
  esac
done

