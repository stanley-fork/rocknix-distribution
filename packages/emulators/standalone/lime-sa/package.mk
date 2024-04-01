# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="lime-sa"
PKG_VERSION="235697e41f0f28237a9dd594f94e6b9038c2d04b"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Lime3DS/Lime3DS"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain ffmpeg mesa SDL2 boost zlib libusb boost zstd control-gen"
PKG_LONGDESC="Lime - Nintendo 3DS emulator"
PKG_TOOLCHAIN="cmake"

if [ ! "${OPENGL}" = "no" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGL} glu libglvnd"
fi

if [ "${OPENGLES_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGLES}"
fi

if [ "${VULKAN_SUPPORT}" = "yes" ]
then
  PKG_DEPENDS_TARGET+=" vulkan-loader vulkan-headers"
fi

PKG_CMAKE_OPTS_TARGET+="-DENABLE_QT=OFF \
                        -DENABLE_QT_TRANSLATION=OFF \
                        -DENABLE_SDL2=ON \
                        -DCITRA_WARNINGS_AS_ERRORS=OFF \
                        -DUSE_DISCORD_PRESENCE=OFF"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
    cp ${PKG_BUILD}/.${TARGET_NAME}/bin/MinSizeRel/lime ${INSTALL}/usr/bin
    cp ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin

  mkdir -p ${INSTALL}/usr/config/lime-emu
    cp -rf ${PKG_DIR}/config/${DEVICE}/* ${INSTALL}/usr/config/lime-emu
}