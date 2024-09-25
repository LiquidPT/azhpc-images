#!/bin/bash
set -ex

# Install AMD Optimizing C/C++ and Fortran Compilers
amd_metadata=$(jq -r '.amd."'"$DISTRIBUTION"'"' <<< $COMPONENT_VERSIONS)
AOCC_VERSION=$(jq -r '.aocc.version' <<< $amd_metadata)
AOCC_SHA256=$(jq -r '.aocc.sha256' <<< $amd_metadata)
AOCC_TARBALL="aocc-compiler-${AOCC_VERSION}.tar"
AOCC_FOLDER_VERSION=$(echo $AOCC_VERSION | cut -d'.' -f1-2 --output-delimiter='-')
AOCC_DOWNLOAD_URL=https://download.amd.com/developer/eula/aocc/aocc-${AOCC_FOLDER_VERSION}/${AOCC_TARBALL}
AOCC_FOLDER=$(basename $AOCC_TARBALL .tar)

INSTALL_PREFIX=/opt/amd

$COMMON_DIR/download_and_verify.sh $AOCC_DOWNLOAD_URL $AOCC_SHA256
tar -xvf ${AOCC_TARBALL}

pushd ${AOCC_FOLDER}
./install.sh
popd
cp -r ${AOCC_FOLDER} ${INSTALL_PREFIX}

$COMMON_DIR/write_component_version.sh "AOCC" ${AOCC_VERSION}
