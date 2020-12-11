# Media driver builder

A simple builder for intel media river.

## Quick start

- build

  1.  chosen which version you want to build

      for example: we want to build 2020 Q3 version

      go to [media-driver releases page](https://github.com/intel/media-driver/releases)

      **Intel Media Driver Q3'2020 Release**

      intel-media-20.3.0

      Dependencies

      - GmmLib: intel-gmmlib-20.3.2
      - Libva: 2.9.0

  2.  edit build script `./build_media_driver.sh`

      ```
      MEDIA_DRIVER_VERSION="20.3.0"
      GMMLIB_VERSION="20.3.2"
      LIBVA_VERSION="2.9.0"
      ```

  3.  start build(make sure you clean first)

      ```
      ./build_media_driver.sh build
      ```

  4.  get output library

      All packages will be install into `out/ `directory

- clean

  ```
  ./build_media_driver.sh clean
  ```

## config

`Intel Media driver` build config: [ubuntu intel-media-driver-non-free](https://launchpad.net/ubuntu/+source/intel-media-driver-non-free)

We refer [20.04 intel-media-driver-no-free build config](https://launchpadlibrarian.net/475527972/buildlog_ubuntu-focal-amd64.intel-media-driver-non-free_20.1.1+ds1-1build1_BUILDING.txt.gz)

```
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=None -DCMAKE_INSTALL_SYSCONFDIR=/etc -DCMAKE_INSTALL_LOCALSTATEDIR=/var -DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON -DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON -DCMAKE_INSTALL_RUNSTATEDIR=/run -DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=ON "-GUnix Makefiles" -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DINSTALL_DRIVER_SYSCONF=OFF -DENABLE_KERNELS=ON -DENABLE_NONFREE_KERNELS=ON -DBUILD_CMRTLIB=OFF ..
```

`libva` and `gmmlib` all use default build config.

## Links

- [media-driver](https://github.com/intel/media-driver/releases)
- [gmmlib](https://github.com/intel/gmmlib/releases)
- [libva](https://github.com/intel/libva/releases)
