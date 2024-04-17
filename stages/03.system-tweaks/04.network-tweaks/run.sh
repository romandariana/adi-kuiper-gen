#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
#
# kuiper2.0 - Embedded Linux for Analog Devices Products
#
# Copyright (c) 2024 Analog Devices, Inc.
# Author: Monica Constandachi <monica.constandachi@analog.com>

chroot "${BUILD_DIR}" << EOF
    if [ -e /lib/udev/rules.d/80-net-setup-link.rules ]; then
        # Change ID_NET_NAME to eth0
        sed -i 's/\"\$env{ID_NET_NAME}\"/\"eth0\"/g' /lib/udev/rules.d/80-net-setup-link.rules
    fi

EOF
