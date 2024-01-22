#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
#
# kuiper2.0 - Embedded Linux for Analog Devices Products
#
# Copyright (c) 2024 Analog Devices, Inc.
# Author: Larisa Radu <larisa.radu@analog.com>

export SCOPY_RELEASE=v1.4.0
export SCOPY_ARCHIVE=Scopy-${SCOPY_RELEASE}-Linux-arm.zip
export SCOPY=https://github.com/analogdevicesinc/scopy/releases/download/${SCOPY_RELEASE}/${SCOPY_ARCHIVE}

if [ "${CONFIG_SCOPY}" = y ]; then
	if [ "${CONFIG_LIBIIO}" = y ]; then

mount -t proc proc "${BUILD_DIR}"/proc

chroot "${BUILD_DIR}" << EOF
		wget ${SCOPY}
		unzip ${SCOPY_ARCHIVE}
		flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
		flatpak install Scopy.flatpak --assumeyes
		rm -rf ${SCOPY_ARCHIVE}
	
		echo "alias scopy='flatpak run org.adi.Scopy'" >> /etc/bash.bashrc
		echo "alias Scopy='flatpak run org.adi.Scopy'" >> /etc/bash.bashrc
	
		umount /proc
EOF

	else
		echo "Cannot install Scopy. Libiio is a dependency and was not set to be installed. Please see the config file for more informations."
	fi
else
	echo "Scopy won't be installed because CONFIG_SCOPY is set to 'n'."
fi
