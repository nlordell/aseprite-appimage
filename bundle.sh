#!/usr/bin/env bash

set -e

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
target="$root/target"
output="$HOME/Applications/Aseprite-x86_64.AppImage"

image="pkg2appimage"
docker="$DOCKER"
if [[ -z $docker ]]; then
	docker="docker"
fi

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
mkdir -p "$target/debs"
deb="$(basename "$root"/Aseprite_*.deb)"
cp "$deb" "$target/debs/${deb/Aseprite/aseprite}"
cp "$root/Aseprite.yml" "$target/"

echo "==> Building AppImage"
"$docker" run \
	-it --rm \
	-v "$target:/app" \
	--device /dev/fuse --cap-add SYS_ADMIN --privileged \
	$image \
	pkg2appimage Aseprite.yml

echo "==> Installing AppImage"
if [[ -x "$(which trash)" ]] && [[ -e "$output" ]]; then
	trash "$output"
fi
cp "$target/out"/*.AppImage "$output"
