#!/bin/bash
set -ex

# Set NVIDIA fabricmanager version
nvidia_fabricmanager_metadata=$(jq -r '.nvidia."'"$DISTRIBUTION"'".fabricmanager' <<< $COMPONENT_VERSIONS)
nvidia_fabricmanager_version=$(jq -r '.version' <<< $nvidia_fabricmanager_metadata)

tdnf install -y nvidia-fabric-manager-$nvidia_fabricmanager_version
sed -i "$ s/$/ nvidia-fabric-manager/" /etc/dnf/dnf.conf

# Temp disable NVIDIA fabricmanager updates
mkdir -p /etc/tdnf/locks.d
echo nvidia-fabric-manager >> /etc/tdnf/locks.d/nvidia.conf

$COMMON_DIR/write_component_version.sh "NVIDIA_FABRIC_MANAGER" $nvidia_fabricmanager_version
