#!/usr/bin/env bash

WORK_DIR=`pwd`
RELEASE_DIR=${WORK_DIR}/release

mkdir -p ${RELEASE_DIR}/lib
ldd ${RELEASE_DIR}/bin/vim | grep libtinfo | awk '{print $3}' > ${RELEASE_DIR}/deps
while read line; do
  echo ${line}
  cp ${line} ${RELEASE_DIR}/lib/
done < ${RELEASE_DIR}/deps

rm ${RELEASE_DIR}/deps
