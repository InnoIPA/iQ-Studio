<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Approved Vendor List

This quick reference lists the Innodisk camera modules and embedded peripheral modules that have been validated on the Q911 family (Qualcomm Dragonwing QCS9075).

> Note: Camera driver patches are maintained in [iQ-Cam__manifest](https://github.com/InnoIPA/iQ-Cam__manifest). Refer there for release packages aligned with your BSP version.


## Supported GMSL Camera Modules

| Model | Interface | Key Specs | Serializer | ISP | Sensor |
| --- | --- | --- | --- | --- | --- |
| [EVDF-OOM1-RHCF](https://www.innodisk.com/en/products/camera/gmsl2/evdf-oom1-rhcf) | GMSL2 | 13MP Fixed Focus | Maxim MAX9295A | onsemi | onsemi AR1335 |
| [EV3F-ZSM1-RXCF](https://www.innodisk.com/en/products/camera/gmsl2) | GMSL2 | 3MP Fixed Focus, HDR LFM | Maxim MAX9295A | Sony | Sony ISX031 |

> Note: Camera test reports are available in the [iQ-Cam test summary](https://github.com/InnoIPA/iQ-Cam__manifest/blob/main/doc/common/test_summary/). New reports will be added there.

## Supported MIPI CSI-2 Camera Modules

| Model | Interface | Key Specs | ISP | Sensor |
| --- | --- | --- | --- | --- |
| [EV2M-OOM3-RHCF](https://www.innodisk.com/en/products/camera/mipi-csi-2/ev2m-oom3-rhcf) | MIPI CSI-2 | 2MP, 30 FPS, HDR, External Trigger | onsemi | onsemi AR0246 |
| [EV8M-OOM1-RHCF](https://www.innodisk.com/en/products/camera/mipi-csi-2/ev8m-oom1-rhcf) | MIPI CSI-2 | 8MP, 30 FPS, HDR, External Trigger | onsemi | onsemi AR0822 |
| [EVDM-OOM1-RHCF](https://www.innodisk.com/en/products/camera/mipi-csi-2/evdm-oom1-rhcf) | MIPI CSI-2 | 13MP, 20 FPS, HDR | onsemi | onsemi AR1335 |

> Note: Camera test reports are available in the [iQ-Cam test summary](https://github.com/InnoIPA/iQ-Cam__manifest/blob/main/doc/common/test_summary/). New reports will be added there.

## Supported Embedded Peripheral Modules

| Model | Interface | Module Type | Key Function | Controller |
| --- | --- | --- | --- | --- |
| [EGPL-G401](https://www.innodisk.com/en/products/networking/lan) | M.2 2280 | LAN module | Four isolated GbE LAN | Intel I350 |
| [EGPL-G201](https://www.innodisk.com/en/products/networking/lan/egpl-g201) | M.2 | LAN module | Dual isolated GbE LAN | Intel I226 |
| [EGPL-G104](https://www.innodisk.com/en/products/networking/lan/egpl-g104) | M.2 2230 | LAN module | Single isolated GbE LAN | Intel I210 |
| [EGPL-T102](https://www.innodisk.com/en/products/networking/lan/egpl-t102) | M.2 2280 | 10GbE LAN module | Single 10GbE LAN | Marvell AQC113 |
| [EGP2-X401](https://www.innodisk.com/en/products/io-modules/serial/egp2-x401-1) | M.2 | Serial module | Four RS-232 / 422 / 485 ports | MaxLinear XR17V354 |
| [EGP2-X403](https://www.innodisk.com/en/products/io-modules/serial/egp2-x403-1) | M.2 2242 | Serial module | Four RS-232 ports | Fintek F81437N |
| [EGPC-B201](https://www.innodisk.com/en/products/embedded-peripheral/communication-canbus/egpc-b201-1) | M.2 2260/2280 | CAN Bus module | Dual isolated CAN Bus 2.0B / J1939 | Microchip PIC32MX |
| [EGPC-B1S1](https://www.innodisk.com/en/products/io-modules/can-bus/egpc-b1s1-1) | M.2 2242 | CAN Bus module | Single isolated CAN Bus 2.0B / J1939 / CANopen | Fintek F81601N |
| [EGUC-F2S3](https://www.innodisk.com/en/products/io-modules/can-bus/eguc-f2s3-1) | M.2 2280 | CAN FD module | Dual isolated CAN FD | Nuvoton M467 |
