#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Please specify package to build"
    exit 1
fi

cp -r "$1" /home/builduser

pushd /home/builduser > /dev/null
chown -R builduser:builduser "$1"

pushd "$1" > /dev/null
su -c '. PKGBUILD && yay -S --noconfirm ${makedepends[@]} ${depends[@]}' builduser
su -c makepkg builduser
popd > /dev/null

popd > /dev/null
