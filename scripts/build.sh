#!/bin/bash

cd $(dirname $0)
cd ..
BASE=$(pwd)

SOURCE_DIR="${BASE}/source"
UPLOAD_DIR="${BASE}/upload"
PACKAGE_DIR="${BASE}/target"

source ${BASE}/project.env

mkdir -p ${UPLOAD_DIR}

# package code

mkdir -p ${PACKAGE_DIR}
pip install -t ${PACKAGE_DIR} -r ${SOURCE_DIR}/python/requirements.txt
rsync -avvP ${SOURCE_DIR}/python/ ${PACKAGE_DIR}
cd ${PACKAGE_DIR}
zip -r ${UPLOAD_DIR}/aws-slack-bridge_${VERSION}_code.zip *
rm -rf ${PACKAGE_DIR}
cd ${BASE}

# package terraform

mkdir -p ${PACKAGE_DIR}
rsync -avvP ${SOURCE_DIR}/terraform/ ${PACKAGE_DIR}
cd ${PACKAGE_DIR}
zip -r ${UPLOAD_DIR}/aws-slack-bridge_${VERSION}_module.zip *
rm -rf ${PACKAGE_DIR}
cd ${BASE}

# list artefacts

ls -lh ${UPLOAD_DIR}
