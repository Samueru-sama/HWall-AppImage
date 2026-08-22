#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm rust

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Building HWall..."
echo "---------------------------------------------------------------"
git clone https://github.com/pulpul-s/HWall ./hwall && (
	cd ./hwall

	git fetch --tags origin
	TAG=$(git tag --sort=-v:refname | grep -vi 'rc\|alpha\|beta' | head -1)
	git checkout "$TAG"

	make install-gui PREFIX=/usr
	echo "$TAG" > ~/version
)
