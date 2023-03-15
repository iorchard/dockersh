#!/bin/bash

HOMEPATH="/data"
ARCHIVEPATH="/archive"
function USAGE() {
  echo "USAGE: $0 [-h|-e|-i] <username>" 1>&2
  echo
  echo " -h --help                   Display this help message."
  echo " -e --external               User type is external."
  echo " -i --internal               User type is internal."
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
      break
      ;;
    -i | --internal)
      GRP="internal"
      break
      ;;
    *)
      echo Error: unknown option: "$OPT" 1>&2
      echo " "
      USAGE
      exit 1
  esac
done

sudo adduser \
  --home ${HOMEPATH}/${USER} \
  --shell /usr/local/bin/dockersh \
  --ingroup ${GRP} \
  --gecos '' \
  ${USER}
sudo adduser ${USER} docker
sudo mkdir -p \
	${HOMEPATH}/${USER}/containerhome/hot \
	${ARCHIVEPATH}/${USER}/cold
sudo chown -R ${USER}:${GRP} \
	${HOMEPATH}/${USER} \
	${ARCHIVEPATH}/${USER}

