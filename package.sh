#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD

repo="$(realpath "${1:-aseprite}")"
build="${2:-"$repo/build"}"

pushd "$build" > /dev/null

echo "===> Fetching linuxdeploy"
if [[ ! -e linuxdeploy ]]; then
    curl -LO https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
    chmod +x linuxdeploy-x86_64.AppImage
    ./linuxdeploy-x86_64.AppImage --appimage-extract
    mv squashfs-root linuxdeploy
    rm linuxdeploy-x86_64.AppImage
else
    echo "nothing to do."
fi
linuxdeploy="$(pwd)/linuxdeploy/usr/bin/linuxdeploy"

echo "===> Installing AppDir"
rm -rf AppDir
"$linuxdeploy" --appdir=AppDir \
    --executable=bin/aseprite \
    --desktop-file="$repo/src/desktop/linux/aseprite.desktop" \
    $(ls bin/data/icons/ase*.png | sed 's/^/--icon-file=/') \
    --icon-filename=aseprite

echo "===> Patching AppDir"
mkdir -p AppDir/usr/share/aseprite
cp -r bin/data AppDir/usr/share/aseprite

echo "===> Packaging AppImage"
VERSION=${ASEPRITE_VERSION:-$(git -C "$repo" rev-parse --short HEAD)} \
"${linuxdeploy}-plugin-appimage" --appdir=AppDir

popd > /dev/null
