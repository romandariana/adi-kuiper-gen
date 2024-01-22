#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
#
# kuiper2.0 - Embedded Linux for Analog Devices Products
#
# Copyright (c) 2024 Analog Devices, Inc.
# Author: Larisa Radu <larisa.radu@analog.com>

if [ "${CONFIG_GRM2K}" = y ]; then
	if [[ "${CONFIG_LIBIIO}" = y  && "${CONFIG_LIBM2K}" = y && "${CONFIG_GNURADIO}" = y ]]; then

chroot "${BUILD_DIR}" << EOF
		cd /usr/local/src

		# Clone gr-m2k
		git clone -b ${BRANCH_GRM2K} ${GITHUB_ANALOG_DEVICES}/gr-m2k.git
	
		# Install gr-m2k
		cd gr-m2k && cmake ${CONFIG_GRM2K_CMAKE_ARGS} && cd build && make -j $NUM_JOBS && make install
EOF

	else
		echo "Cannot install Grm2k. Libiio, Libm2k and Gnuradio are dependencies and one or more of them were not set to be installed. \
Please see the config file for more informations."
	fi
else
	echo "Grm2k won't be installed because CONFIG_GRM2K is set to 'n'."
fi
