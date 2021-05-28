# Aseprite AppImage Bundling

Aseprite AppImage bundling scripts.

## Usage

Simply build Aseprite following the [official instructions](https://github.com/aseprite/aseprite/blob/main/INSTALL.md).
Alternatively, a helper script to automate the process is provided:
```
[ASEPRITE_VERSION=...] [SKIA_VERSION=...] ./build.sh
```

Then, package up the bundled files.
```
[ASEPRITE_VERSION=...] ./package.sh [$PATH_TO_ASEPRITE_REPO [$PATH_TO_ASEPRITE_BUILD]]
```

If Aseprite was built with the aforementioned helper script, simply:
```
[ASEPRITE_VERSION=...] ./package.sh
```

## Docker

A `Dockerfile` is provided to simplify the whole process.
```
docker build -t localhost/aseprite-build docker
docker run -it --rm \
    -v $(pwd):/src:z \
    [-e ASEPRITE_VERSION=...] [-e SKIA_VERSION=...] \
    localhost/aseprite-build
```

## Legacy Scripts

For legacy scripts that repackaged official Aseprite .deb releases, see the `deb` branch.
