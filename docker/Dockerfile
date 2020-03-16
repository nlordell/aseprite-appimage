FROM registry.fedoraproject.org/f31/fedora-toolbox:31

RUN mkdir -p /app /opt && \
    dnf install -y apt desktop-file-utils dpkg file fuse-libs && \
    git clone --depth 1 https://github.com/AppImage/pkg2appimage.git /opt/pkg2appimage
ENV PATH="/opt/pkg2appimage:${PATH}"
WORKDIR /app
