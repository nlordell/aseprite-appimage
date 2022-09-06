#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD

echo "===> Fetching Aseprite source"
if [[ ! -e aseprite ]]; then
    ref=${ASEPRITE_VERSION:-v1.2.40}
    git clone --recursive --depth 1 --branch $ref \
        https://github.com/aseprite/aseprite.git
else
    echo "nothing to do."
fi

mkdir -p aseprite/build
pushd aseprite/build >/dev/null

echo "===> Retrieving pre-built Skia library"
if [[ ! -e skia ]]; then
    rel=${SKIA_VERSION:-m102-861e4743af}
    curl -OL https://github.com/aseprite/skia/releases/download/$rel/Skia-Linux-Release-x64-libstdc++.zip
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
if [[ -n $ASEPRITE_VERSION ]]; then
    echo "#define VERSION \"${ASEPRITE_VERSION#v}\"" >src/ver/generated_version.h
fi
ninja aseprite

popd >/dev/null
