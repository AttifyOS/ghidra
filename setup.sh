#!/bin/bash

set -e

if [[ -z "${APM_TMP_DIR}" ]]; then
  echo "APM_TMP_DIR is not set"
  exit 1
fi

if [[ -z "${APM_PKG_INSTALL_DIR}" ]]; then
  echo "APM_PKG_INSTALL_DIR is not set"
  exit 1
fi

wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.1.5_build/ghidra_10.1.5_PUBLIC_20220726.zip -O $APM_TMP_DIR/ghidra_10.1.5_PUBLIC_20220726.zip
unzip $APM_TMP_DIR/ghidra_10.1.5_PUBLIC_20220726.zip -d $APM_PKG_INSTALL_DIR