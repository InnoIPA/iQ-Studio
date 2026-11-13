# MIPI Camera

MIPI CSI-2 is a widely adopted camera interface standard designed for high-bandwidth, low-power, and low-latency transmission between image sensors and processing SoCs.

It supports multi-gigabit throughput per lane, enabling high-resolution and high-frame-rate video pipelines for modern imaging applications.

With its mature ecosystem and broad sensor compatibility, MIPI CSI-2 is commonly used in autonomous driving, industrial automation, robotics, medical imaging, and AI edge devices.

For more information about MIPI Camera, please visit https://github.com/InnoIPA/iQ-Cam__manifest

## Supported MIPI CSI-2 Camera Modules

| Model | Interface | Key Specs | ISP | Sensor |
| --- | --- | --- | --- | --- |
| [EV2M-OOM3-RHCF](https://www.innodisk.com/en/products/camera/mipi-csi-2/ev2m-oom3-rhcf) | MIPI CSI-2 | 2MP, 30 FPS, HDR, External Trigger | onsemi | onsemi AR0246 |
| [EV8M-OOM1-RHCF](https://www.innodisk.com/en/products/camera/mipi-csi-2/ev8m-oom1-rhcf) | MIPI CSI-2 | 8MP, 30 FPS, HDR, External Trigger | onsemi | onsemi AR0822 |
| [EVDM-OOM1-RHCF](https://www.innodisk.com/en/products/camera/mipi-csi-2/evdm-oom1-rhcf) | MIPI CSI-2 | 13MP, 20 FPS, HDR | onsemi | onsemi AR1335 |

> Note: Camera driver patches, release packages for each BSP version, usage guides, and test reports are maintained in [iQ-Cam__manifest](https://github.com/InnoIPA/iQ-Cam__manifest). Refer there for the package that matches your BSP version, and to the [iQ-Cam test summary](https://github.com/InnoIPA/iQ-Cam__manifest/blob/main/doc/common/test_summary/) for test reports.