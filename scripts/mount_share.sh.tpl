#!/bin/bash

# Install CIFS utilities for SMB
apt-get update -y
apt-get install -y cifs-utils

# Create mount point
mkdir -p /mnt/${file_share_name}

# Mount the Azure File Share using SMB
mount -t cifs //${storage_account_name}.file.core.windows.net/${file_share_name} /mnt/${file_share_name} -o vers=3.0,username=${storage_account_name},password=${storage_account_key},dir_mode=0777,file_mode=0777,serverino

# Add to fstab for persistence across reboots
echo "//${storage_account_name}.file.core.windows.net/${file_share_name} /mnt/${file_share_name} cifs vers=3.0,username=${storage_account_name},password=${storage_account_key},dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab