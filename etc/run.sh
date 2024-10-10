#!/usr/bin/env bash
set -ex
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

(
  (( $EUID == 0 )) && SUDO='' || SUDO='sudo'

  curl -o ./pkgx --compressed -f --proto '=https' https://pkgx.sh/$(uname)/$(uname -m)
  chmod +x pkgx && $SUDO mv pkgx /usr/local/bin

  [ -d "/io" ] && cd /io || cd "$CWD/../.."

  $SUDO pkgx install -y task terraform ansible packer gcc
  gcc -v
  task -v
  terraform -v
  packer -v
  ansible --version
  python3 -m venv .venv
  (
    . .venv/bin/activate
    export PATH="$PWD/.venv/bin:$PATH"
    python3 -m pip install pip -U
    python3 -m pip install Cython
    python3 -m pip install python-openstackclient
    openstack --version || (echo "no openstack install error" && exit 1)
    task init
    cp .constructor/build.env.sample build.env
    task
    task constructor:init
    task provisioner:init
    task constructor:fetch
  )
)
