FROM docker.io/library/ubuntu:xenial

RUN mkdir -p /app /opt && \
    apt-get update -y && \
    apt-get install -y binutils curl desktop-file-utils file git libfuse2 wget && \
    git clone --depth 1 https://github.com/AppImage/pkg2appimage.git /opt/pkg2appimage
ENV PATH="/opt/pkg2appimage:${PATH}"
ENV DOCKER_BUILD=1
WORKDIR /app
