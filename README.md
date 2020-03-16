# Aseprite AppImage Bundling

A script and Dockerfile for repackaging officially released Aseprite .deb
packages into AppImages.

## Usage

The easiest way to run the script is to copy an Aseprite `.deb` package into the
root of this repository and run:

```
./bundle.sh
```

This will produce a `target/out` directory with the bundled AppImage.

Note that a `.deb` package can also be manually specified. Additionally, he
script also works with Podman (instead of Docker) and can automatically install
the repackaged AppImage to `$HOME/Applications`:

```
./bundle.sh -p ~/Downloads/Aseprite_*.deb --podman --install
```
