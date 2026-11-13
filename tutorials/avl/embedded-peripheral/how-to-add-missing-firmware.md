<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# How to Add Missing Firmware

The BSP may already include the driver for a module while its firmware file is missing from the image. In this case the driver fails to probe, or the kernel log reports `firmware: failed to load`.

This guide shows how to add the missing firmware to a Yocto image. It requires the BSP source workspace. If you only have a flashed image, please contact Innodisk for an updated image.

> Note: On Ubuntu, install the firmware with `apt` (for example, `sudo apt install linux-firmware`) instead.

## 1. Find the Missing File

Check the kernel log for the missing file name:

```bash
dmesg | grep -i firmware
```

For example: `iwlwifi-ty-a0-gf-a0-83.ucode`.

## 2. Check Whether Upstream Has It

Search for the file name in the upstream [linux-firmware](https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git) repository, then check whether the `linux-firmware` recipe in your BSP workspace provides it:

```bash
bitbake -e linux-firmware | grep ^PACKAGES=
```

- The file is in a `linux-firmware-*` package: use **Option A**.
- The file is missing, or the recipe version is too old: use **Option B**.

## Option A: Enable the linux-firmware Package

1. Add the matching package to your image, in `local.conf` or the image recipe:

   ```
   IMAGE_INSTALL:append = " linux-firmware-iwlwifi"
   ```

   Replace `linux-firmware-iwlwifi` with the package that provides your file.

2. Rebuild the image and flash it.
3. Boot and run `dmesg | grep -i firmware` to confirm the error is gone.

## Option B: Write a Firmware Recipe

1. Put the firmware files in the `files/` folder of a new recipe, for example `recipes-apps/<module>-fw/files/`.
2. Write the recipe. Use `recipes-apps/ax210ngw-fw/ax210ngw-fw.bb` in `meta-innodisk-iq` as an example. It does three things:
   - lists the files in `SRC_URI`
   - installs them to `${nonarch_base_libdir}/firmware/` in `do_install`
   - lists the installed files in `FILES:${PN}`
3. Add the recipe to your image:

   ```
   IMAGE_INSTALL:append = " <module>-fw"
   ```

4. Rebuild the image and flash it.
5. Boot and run `dmesg | grep -i firmware` to confirm the error is gone.

> Note: Check the license of the firmware file before you redistribute it.
