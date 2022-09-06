FROM docker.io/library/ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        g++ clang cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev \
        curl file git zip

WORKDIR /src
ENV ASEPRITE_VERSION=
ENV SKIA_VERSION=

CMD ./build.sh && ./package.sh
