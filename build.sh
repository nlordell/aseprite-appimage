#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD

latest() {
    local repo="$1"
    curl --silent "https://api.github.com/repos/$repo/releases/latest" |
        grep '"tag_name":' |
        sed -E 's/^.*"tag_name"\s*:\s*"([^"]*)".*$/\1/'
}

ASEPRITE_VERSION="${ASEPRITE_VERSION:-$(latest aseprite/aseprite)}"
SKIA_VERSION="${SKIA_VERSION:-$(latest aseprite/skia)}"
echo "===> Building Aseprite ${ASEPRITE_VERSION} (Skia ${SKIA_VERSION})"

echo "===> Fetching Aseprite source"
if [[ ! -e aseprite ]]; then
    git clone --recursive --depth 1 --branch $ASEPRITE_VERSION \
        https://github.com/aseprite/aseprite.git
else
    echo "nothing to do."
fi

mkdir -p aseprite/build
pushd aseprite/build >/dev/null

echo "===> Retrieving pre-built Skia library"
if [[ ! -e skia ]]; then
    curl -OL https://github.com/aseprite/skia/releases/download/$SKIA_VERSION/Skia-Linux-Release-x64-libstdc++.zip
    unzip Skia-Linux-Release-x64-libstdc++.zip -d skia
    rm Skia-Linux-Release-x64-libstdc++.zip
else
    echo "nothing to do."
fi
skia=$(pwd)/skia

echo "===> Building Aseprite"
export CC=clang
export CXX=clang++
cmake \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_CXX_FLAGS:STRING=-stdlib=libstdc++ \
    -DCMAKE_EXE_LINKER_FLAGS:STRING=-stdlib=libstdc++ \
    -DLAF_BACKEND=skia \
    -DSKIA_DIR=$skia \
    -DSKIA_LIBRARY_DIR=$skia/out/Release-x64 \
    -DSKIA_LIBRARY=$skia/out/Release-x64/libskia.a \
    -DWITH_DESKTOP_INTEGRATION=on \
    -DENABLE_CCACHE=off \
    -G Ninja \
    ..
echo "#define VERSION \"${ASEPRITE_VERSION#v}\"" >src/ver/generated_version.h
ninja aseprite

popd >/dev/null
