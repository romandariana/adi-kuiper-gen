#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
#
# kuiper2.0 - Embedded Linux for Analog Devices Products
#
# Copyright (c) 2024 Analog Devices, Inc.
# Author: Larisa Radu <larisa.radu@analog.com>

if [ "${CONFIG_DESKTOP}" = y ]; then

chroot "${BUILD_DIR}" << EOF
	# Enable autologin for analog user
	sed -i "s/#autologin-user=/autologin-user=analog/g" /etc/lightdm/lightdm.conf
	sed -i "s/#autologin-user-timeout=0/autologin-user-timeout=0/g" /etc/lightdm/lightdm.conf
	sed -i "s/#logind-check-graphical=false/logind-check-graphical=true/g" /etc/lightdm/lightdm.conf
	
	# Create only one workspace
	sed -i "s/^workspace_count=.*$/workspace_count=1/g" /usr/share/xfwm4/defaults
	
	echo "export CHROMIUM_FLAGS=\"\$CHROMIUM_FLAGS --password-store=basic\"" >> /etc/chromium.d/default-flags
EOF

	if [ "${CONFIG_RPI_BOOT_FILES}" = y ]; then
		# Uncomment raspi.list repository
		sed -i 's/deb /#deb /' "${BUILD_DIR}/etc/apt/sources.list"
		sed -i 's/#deb /deb /' "${BUILD_DIR}/etc/apt/sources.list.d/raspi.list"
		
		# Install wifi firmware for Raspberry PI from raspi.list
		# Wifi firmware package from raspi.list contains files for RPI Zero W and RPI 3 
		# in addition to the package from Debian repository
chroot "${BUILD_DIR}" << EOF
		apt-get update
		apt-get install -y firmware-brcm80211 --no-install-recommends
EOF
		
		# Comment raspi.list repository
		sed -i 's/deb /#deb /' "${BUILD_DIR}/etc/apt/sources.list.d/raspi.list"
		sed -i 's/#deb /deb /' "${BUILD_DIR}/etc/apt/sources.list"
		
		cat ${BUILD_DIR}/etc/apt/sources.list
		cat ${BUILD_DIR}/etc/apt/sources.list.d/raspi.list

chroot "${BUILD_DIR}" << EOF
		apt-get update
EOF

	fi
else
	echo "XFCE desktop environment won't be installed because CONFIG_DESKTOP is set to 'n'."
fi
