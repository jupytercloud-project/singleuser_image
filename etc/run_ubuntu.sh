#!/usr/bin/env bash
set -ex
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
  cd $CWD && $SUDO apt-get update
  (( $EUID == 0 )) && SUDO='' || SUDO='sudo'
  curl -V || $SUDO apt-get install -y curl
  python3 -m venv -h || $SUDO apt-get install -y python3-venv
  python3-config || $SUDO apt update && $SUDO apt-get install -y python3-dev git
  chmod +x run.sh && ./run.sh
)
