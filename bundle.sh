#!/usr/bin/env bash

set -e

docker=docker
install=
pkg="$(ls -1 | grep 'Aseprite_.*.deb' | tail -1)"
while [[ "$#" -gt 0 ]]; do
	case $1 in
		--podman) docker=podman;;
		--install) install=y;;
		-p|--package) pkg="$2"; shift;;
		-h|--help) cat << EOF
bundle.sh
Bundles an Aseprite .deb release into an AppImage

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --podman              Use Podman instead of Docker
    --install             Installs the AppImage to '\$Home/Applications'
    -p, --package <PKG>   The Aseprite .deb package to bundle into an AppImage,
                          if no package is specified, it defaults to searching
                          for a .deb package in the current directory
    -h, --help            Prints this help information
EOF
			exit;;
		*) >&2 cat << EOF
ERROR: unknown argument '$1'
       use \`$0 --help\` for more information
EOF
			exit 1;;
	esac
	shift
done

if [[ -z "$pkg" ]] || [[ ! -f "$pkg" ]]; then
	>&2 echo "ERROR: invalid or missing Aseprite package file"
	exit 1
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
target="$root/target"
output="$HOME/Applications/Aseprite-x86_64.AppImage"
image="pkg2appimage"

echo "==> Building pkg2appimage image"
"$docker" build --pull -t "$image" "$root/docker"

echo "==> Creating target directory"
if [[ -e "$target" ]]; then
	if [[ -x "$(which trash)" ]]; then
		trash "$target"
	else
		echo "rm $target"
		rm -rfI "$target"
	fi
fi
mkdir -p "$target/packages"
cp "$pkg" "$target/packages/${pkg/Aseprite/aseprite}"
cp "$root/Aseprite.yml" "$target/"

echo "==> Building AppImage"
"$docker" run \
	-it --rm \
	-v "$target:/app:z" \
	--device /dev/fuse \
	$image \
	pkg2appimage Aseprite.yml

if [[ $install == y ]]; then
	echo "==> Installing AppImage"
	mkdir -p "$(dirname $output)"
	if [[ -x "$(which trash)" ]] && [[ -e "$output" ]]; then
		trash "$output"
	fi
	cp "$target/out"/*.AppImage "$output"
fi
