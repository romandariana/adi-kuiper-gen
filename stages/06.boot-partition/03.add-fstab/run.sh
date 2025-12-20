#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
#
# kuiper2.0 - Embedded Linux for Analog Devices Products
#
# Copyright (c) 2024 Analog Devices, Inc.
# Author: Larisa Radu <larisa.radu@analog.com>

SCRIPT_DIR="${BASH_SOURCE%/run.sh}"

install -v -m 644 "${SCRIPT_DIR}"/files/fstab "${BUILD_DIR}/etc/fstab"
install -v -m 644 "${SCRIPT_DIR}"/files/README.txt "${BUILD_DIR}/boot/"
