#!/usr/bin/env bash
set -ex
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
  cd $CWD
  (( $EUID == 0 )) && SUDO='' || SUDO='sudo'
  curl -V || $SUDO dnf install -y curl

  python3-config || $SUDO dnf install -y python3-devel glibc-headers git
  chmod +x run.sh && ./run.sh
)
