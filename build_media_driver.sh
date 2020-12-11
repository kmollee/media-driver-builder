#!/bin/bash

PWD="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
WORK_DIR="${PWD}/workspace"
OUT_DIR="${PWD}/out"
DOWNLOAD_DIR="${PWD}/download"
MEDIA_DRIVER_VERSION="20.3.0"
GMMLIB_VERSION="20.3.2"
LIBVA_VERSION="2.9.0"


function build() {
	[ -d ${WORK_DIR} ] || mkdir -p ${WORK_DIR}
	[ -d ${OUT_DIR} ] || mkdir -p ${OUT_DIR}
	[ -d ${DOWNLOAD_DIR} ] || mkdir -p ${DOWNLOAD_DIR}

	[ -f media-driver.tar.gz ] || wget -O "${DOWNLOAD_DIR}/media-driver.tar.gz" https://github.com/intel/media-driver/archive/intel-media-${MEDIA_DRIVER_VERSION}.tar.gz 
	[ -f libva.tar.gz ] || wget -O "${DOWNLOAD_DIR}/libva.tar.gz" https://github.com/intel/libva/archive/${LIBVA_VERSION}.tar.gz
	[ -f gmmlib.tar.gz ] || wget -O "${DOWNLOAD_DIR}/gmmlib.tar.gz" https://github.com/intel/gmmlib/archive/intel-gmmlib-${GMMLIB_VERSION}.tar.gz


	tar xf "${DOWNLOAD_DIR}/media-driver.tar.gz" -C ${WORK_DIR} --one-top-level=media-driver --strip-components 1
	tar xf "${DOWNLOAD_DIR}/libva.tar.gz" -C ${WORK_DIR} --one-top-level=libva --strip-components 1
	tar xf "${DOWNLOAD_DIR}/gmmlib.tar.gz" -C ${WORK_DIR} --one-top-level=gmmlib --strip-components 1


	echo "start build gmmlib..."
	cd ${WORK_DIR}/gmmlib
	mkdir -p build && cd build
	cmake -DCMAKE_BUILD_TYPE=Release ..
	make -j"$(nproc)" && make DESTDIR=${OUT_DIR} install -s

	echo "start build libva..."
	cd ${WORK_DIR}/libva
	meson build
	cd build && ninja && DESTDIR=${OUT_DIR} ninja install


	echo "start build media-driver..."
	mkdir -p ${WORK_DIR}/media-driver/build
	cd ${WORK_DIR}/media-driver/build && cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=None -DCMAKE_INSTALL_SYSCONFDIR=/etc -DCMAKE_INSTALL_LOCALSTATEDIR=/var -DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON -DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON -DCMAKE_INSTALL_RUNSTATEDIR=/run -DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=ON "-GUnix Makefiles" -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DINSTALL_DRIVER_SYSCONF=OFF -DENABLE_KERNELS=ON -DENABLE_NONFREE_KERNELS=ON -DBUILD_CMRTLIB=OFF ..
	make -j"$(nproc)" && make DESTDIR=${OUT_DIR} install
	# strip debug symbol
	[ ! -f ${OUT_DIR}/usr/local/lib/x86_64-linux-gnu/dri/iHD_drv_video.so ] || strip ${OUT_DIR}/usr/local/lib/x86_64-linux-gnu/dri/iHD_drv_video.so

	echo "all packages has been install into ${OUT_DIR}"
}

function clean() {
	rm -rf ${WORK_DIR}
	rm -rf ${OUT_DIR}
	rm -rf ${DOWNLOAD_DIR}
}

case $1 in
	build)
		build
		;;
	clean)
		clean
		;;
	*)
	echo "Usage: $0 {build|clean}"
	exit 1
esac

exit 0
	
