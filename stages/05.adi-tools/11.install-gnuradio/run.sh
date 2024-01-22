#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
#
# kuiper2.0 - Embedded Linux for Analog Devices Products
#
# Copyright (c) 2024 Analog Devices, Inc.
# Author: Larisa Radu <larisa.radu@analog.com>

if [ "${CONFIG_GNURADIO}" = y ]; then
	# Add trixie.list to sources.list
	install -m 644 "${BASH_SOURCE%%/run.sh}"/files/trixie.list "${BUILD_DIR}/etc/apt/sources.list.d/trixie.list"

	sed -i 's/deb /#deb /' "${BUILD_DIR}/etc/apt/sources.list"

# Install Gnuradio 3.10.8 from Debian 13 Trixie. This version contains bug fixes from ADI libraries.
chroot "${BUILD_DIR}" << EOF
	apt-get update
	apt-get install -y gnuradio gnuradio-dev --no-install-recommends
EOF

	# Comment trixie.list
	sed -i 's/deb /#deb /' "${BUILD_DIR}/etc/apt/sources.list.d/trixie.list"
	sed -i 's/#deb /deb /' "${BUILD_DIR}/etc/apt/sources.list"

chroot "${BUILD_DIR}" << EOF
		apt-get update
EOF

else
	echo "Gnuradio won't be installed because CONFIG_GNURADIO is set to 'n'."
fi
