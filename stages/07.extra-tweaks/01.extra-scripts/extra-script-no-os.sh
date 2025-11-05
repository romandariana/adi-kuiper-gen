#!/bin/bash -e
# SPDX-License-Identifier: BSD-3-Clause
#
# kuiper2.0 - Embedded Linux for Analog Devices Products
#
# Copyright (c) 2025 Analog Devices, Inc.
# Author: Alisa-Dariana Roman <alisa.roman@analog.com>

apt update
apt install -y \
    gcc-arm-none-eabi \
    libusb-0.1-4 \
    libusb-1.0-0 \
    libusb-1.0-0-dev \
    libftdi-dev \
    libftdi1-dev \
    libgpiod2 \
    libhidapi-dev \
    libhidapi-libusb0 \
    python3-pygame \
    picocom

# Install Visual Studio Code
wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64"
echo "n" | dpkg -i vscode.deb
rm vscode.deb

echo 'alias code="code --use-inmemory-secretstorage"' >> /etc/bash.bashrc

# Set hostname
sed -i 's/analog/workshops/g' /etc/hostname
sed -i 's/analog/workshops/g' /etc/hosts

# Setup no-OS workshop
mkdir -p /home/analog
cd /home/analog
git clone https://github.com/romandariana/workshop_baremetal.git

cd workshop_baremetal

WORKSHOP_DIR="/home/analog/workshop_baremetal"
NO_OS_REPO="https://github.com/romandariana/no-OS.git"
NO_OS_BRANCH="workshop"
AI8X_REPO="https://github.com/analogdevicesinc/ai8x-synthesis.git"
MAX_SDK_ZIP="MAX78000SDK.zip"

cp stages/07.extra-tweaks/01.extra-scripts/workshops/99-daplink.rules /etc/udev/rules.d/

usermod -a -G tty analog

mkdir -p "$WORKSHOP_DIR"

if [ -d "$WORKSHOP_DIR/no-OS" ]; then
    echo "no-OS already exists, skipping"
else
    cd "$WORKSHOP_DIR"
    git clone --depth 2 -b "$NO_OS_BRANCH" "$NO_OS_REPO"
fi

if [ -d "$WORKSHOP_DIR/ai8x-synthesis" ]; then
    echo "ai8x-synthesis already exists, skipping"
else
    cd "$WORKSHOP_DIR"
    git clone --depth 1 "$AI8X_REPO"
fi

if [ -d "$WORKSHOP_DIR/MAX78000SDK" ]; then
    echo "MAX78000SDK already exists, skipping"
else
    cd "$WORKSHOP_DIR"
    wget https://swdownloads.analog.com/cse/kuiper/kuiperv2.0.0/university-workshops/"$MAX_SDK_ZIP"
    unzip "$MAX_SDK_ZIP"
    rm "$MAX_SDK_ZIP"
fi
