pkgname=aseprite-bin
pkgver=1.2.15_1
pkgrel=1
pkgdesc="Animated sprite editor and pixel art tool"
url="https://www.aseprite.org/"
arch=("x86_64")
license=("custom")
depends=("glibc" "gcc-libs" "libx11")
provides=("aseprite-bin")
conflicts=("aseprite" "aseprite-gpl" "aseprite-git")

source=("Aseprite_${pkgver/_/-}_amd64.deb")
md5sums=("SKIP")

package() {
    bsdtar -C "${pkgdir}" -xf "${srcdir}/data.tar.xz"
}