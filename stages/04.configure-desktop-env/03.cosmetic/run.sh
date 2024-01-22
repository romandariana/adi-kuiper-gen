#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
#
# kuiper2.0 - Embedded Linux for Analog Devices Products
#
# Copyright (c) 2024 Analog Devices, Inc.
# Author: Larisa Radu <larisa.radu@analog.com>

if [ "${CONFIG_DESKTOP}" = y ]; then

mkdir "${BUILD_DIR}/usr/share/adi-wallpaper"
install -m 644 "${BASH_SOURCE%%/run.sh}"/files/wallpaper.png "${BUILD_DIR}/usr/share/adi-wallpaper"
rm "${BUILD_DIR}/usr/share/icons/hicolor/16x16/apps/org.xfce.panel.applicationsmenu.png"
install -m 644 "${BASH_SOURCE%%/run.sh}"/files/org.xfce.panel.applicationsmenu.png "${BUILD_DIR}/usr/share/icons/hicolor/16x16/apps"

chroot "${BUILD_DIR}" << EOF
	# Set theme to dark
	sed -i "s/Xfce/Adwaita-dark/g" /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

	# Set adi-wallpaper to all workspaces
	rm /usr/share/images/desktop-base/default
	ln -s /usr/share/adi-wallpaper/wallpaper.png /usr/share/images/desktop-base/default

	# Disable screen saver
	sed -i '/exec xfce4-session/i    xset s off -dpms' /etc/xdg/xfce4/xinitrc
EOF

else
	echo "Desktop cosmetics won't be installed because CONFIG_DESKTOP is set to 'n'."
fi
