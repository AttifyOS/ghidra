#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${APM_TMP_DIR}" ]]; then
    echo "APM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_INSTALL_DIR}" ]]; then
    echo "APM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_BIN_DIR}" ]]; then
    echo "APM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.2_build/ghidra_10.2_PUBLIC_20221101.zip -O $APM_TMP_DIR/ghidra_10.2_PUBLIC_20221101.zip
  unzip $APM_TMP_DIR/ghidra_10.2_PUBLIC_20221101.zip -d $APM_PKG_INSTALL_DIR
  rm $APM_TMP_DIR/ghidra_10.2_PUBLIC_20221101.zip

  wget https://corretto.aws/downloads/resources/11.0.16.8.1/amazon-corretto-11.0.16.8.1-linux-x64.tar.gz -O $APM_TMP_DIR/amazon-corretto-11.0.16.8.1-linux-x64.tar.gz
  tar xf $APM_TMP_DIR/amazon-corretto-11.0.16.8.1-linux-x64.tar.gz -C $APM_PKG_INSTALL_DIR

  echo "#!/usr/bin/env sh" > $APM_PKG_BIN_DIR/ghidra
  echo "export PATH=$APM_PKG_INSTALL_DIR/amazon-corretto-11.0.16.8.1-linux-x64/bin/:\$PATH" >> $APM_PKG_BIN_DIR/ghidra
  echo "$APM_PKG_INSTALL_DIR/ghidra_10.2_PUBLIC/ghidraRun \"\$@\"" >> $APM_PKG_BIN_DIR/ghidra
  chmod +x $APM_PKG_BIN_DIR/ghidra
}

uninstall() {
  rm $APM_PKG_BIN_DIR/ghidra
  rm -rf $APM_PKG_INSTALL_DIR/ghidra_10.2_PUBLIC
  rm -rf $APM_PKG_INSTALL_DIR/amazon-corretto-11.0.16.8.1-linux-x64
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1