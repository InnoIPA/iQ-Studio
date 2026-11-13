<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->


# Embedded Peripheral Modules

The **Yocto (QLI)** column shows the Innodisk Yocto release tag and, in parentheses, the Qualcomm Linux (QLI) BSP version used for testing, for example `v0.0.1 (1.5)`. The **Ubuntu** column shows the Ubuntu build used for testing. A `-` means the module has not been tested on that OS.

> Note: Modules are tested on the BSP version listed in the table. Other Yocto BSP versions should generally work as well, but we do not test every module on every BSP release. If you use a different version, please verify the module on your own image.

## LAN, Serial, and CAN Bus Modules

| Model | Interface | Module Type | Key Function | Controller | Yocto (QLI) | Ubuntu |
| --- | --- | --- | --- | --- | --- | --- |
| [EGPL-G401](https://www.innodisk.com/en/products/networking/lan) | M.2 2280 | LAN module | Four isolated GbE LAN | Intel I350 | v0.0.1 (1.5) | - |
| [EGPL-G201](https://www.innodisk.com/en/products/networking/lan/egpl-g201) | M.2 | LAN module | Dual isolated GbE LAN | Intel I226 | v0.0.1 (1.5) | - |
| [EGPL-G104](https://www.innodisk.com/en/products/networking/lan/egpl-g104) | M.2 2230 | LAN module | Single isolated GbE LAN | Intel I210 | v0.0.1 (1.5) | - |
| [EGPL-T102](https://www.innodisk.com/en/products/networking/lan/egpl-t102) | M.2 2280 | 10GbE LAN module | Single 10GbE LAN | Marvell AQC113 | v0.0.1 (1.5) | - |
| [EGP2-X401](https://www.innodisk.com/en/products/io-modules/serial/egp2-x401-1) | M.2 | Serial module | Four RS-232 / 422 / 485 ports | MaxLinear XR17V354 | v0.0.1 (1.5) | - |
| [EGP2-X403](https://www.innodisk.com/en/products/io-modules/serial/egp2-x403-1) | M.2 2242 | Serial module | Four RS-232 ports | Fintek F81437N | v0.0.1 (1.5) | - |
| [F81504A](https://www.innodisk.com/en/products/io-modules/serial) | PCIe | Serial module | Four serial ports | Fintek F81504A | v2.3.3 (1.8) | - |
| [EGPC-B201](https://www.innodisk.com/en/products/embedded-peripheral/communication-canbus/egpc-b201-1) | M.2 2260/2280 | CAN Bus module | Dual isolated CAN Bus 2.0B / J1939 | Microchip PIC32MX | v0.0.1 (1.5) | - |
| [EGPC-B1S1](https://www.innodisk.com/en/products/io-modules/can-bus/egpc-b1s1-1) | M.2 2242 | CAN Bus module | Single isolated CAN Bus 2.0B / J1939 / CANopen | Fintek F81601N | v0.0.1 (1.5) | - |
| [EGPC-B4S1](https://www.innodisk.com/en/products/io-modules/can-bus) | M.2 | CAN Bus module | Four isolated CAN Bus | - | v0.0.1 (1.5) | - |
| [EGUC-F2S3](https://www.innodisk.com/en/products/io-modules/can-bus/eguc-f2s3-1) | M.2 2280 | CAN FD module | Dual isolated CAN FD | Nuvoton M467 | v0.0.1 (1.5) | - |
| [EMUC-B202](https://www.innodisk.com/en/products/io-modules/can-bus) | USB | CAN Bus module | Dual isolated CAN Bus (USB to CAN) | - | v2.3.4 (1.8) | - |
| [EMUC-B2S3](https://www.innodisk.com/en/products/io-modules/can-bus) | USB | CAN Bus module | Dual isolated CAN Bus (USB to CAN) | - | v2.3.4 (1.8) | - |

## Wi-Fi / Bluetooth Modules

| Model | Interface | Key Function | Controller | Yocto (QLI) | Ubuntu |
| --- | --- | --- | --- | --- | --- |
| Intel Wi-Fi 6E AX210NGW | M.2 E-key | Wi-Fi 6E + Bluetooth 5.3 | Intel AX210 | v2.3.3 (1.8) | ubuntu_x15 |
| Intel Wi-Fi 6 AX200NGW | M.2 E-key | Wi-Fi 6 + Bluetooth 5.2 | Intel AX200 | v2.3.3 (1.8) | - |
| Intel Wi-Fi 7 BE200 | M.2 E-key | Wi-Fi 7 + Bluetooth 5.4 | Intel BE200 | v2.3.3 (1.8) | - |
| Intel Dual Band 3165NGW | M.2 E-key | Wi-Fi 5 + Bluetooth 4.2 | Intel 3165 | v2.3.2 | - |

> Note: The BSP may include the driver for a Wi-Fi / Bluetooth module while its firmware file is missing from the image. The driver then fails to probe, or the kernel log reports `firmware: failed to load`. See [How to Add Missing Firmware](./how-to-add-missing-firmware.md) to find and add the missing file.
