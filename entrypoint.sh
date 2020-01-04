#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Please specify package to build"
    exit 1
fi

pushd pkg/aur > /dev/null
sed -i "s/^pkgver=.*\$/pkgver=${GITHUB_REF/refs\/tags\/k/}/" "$1"/PKGBUILD
cp -r "$1" /home/builduser
popd > /dev/null

pushd /home/builduser > /dev/null
chown -R builduser:builduser "$1"

pushd "$1" > /dev/null
su -c updpkgsums builduser
su -c '. PKGBUILD; yay -S --noconfirm ${makedepends[@]} ${depends[@]}' builduser
su -c makepkg builduser
popd > /dev/null

popd > /dev/null
