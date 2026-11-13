# GMSL Camera

GMSL provides a highly flexible interface for camera installation. 

Unlike MIPI CSI-2, which typically supports only short-range connections of several tens of centimeters, GMSL enables long-distance video transmission up to 10–15 meters over a single coaxial cable. This allows cameras to be placed several meters away from the platform while maintaining low latency and high reliability.

GMSL is widely used in autonomous driving, industrial mobile equipment, 360° surround-view stitching, and multi-channel real-time AI recognition applications.

For more information about GMSL Camera, please visit https://github.com/InnoIPA/iQ-Cam__manifest

## Supported GMSL Camera Modules

| Model | Interface | Key Specs | Serializer | ISP | Sensor |
| --- | --- | --- | --- | --- | --- |
| [EVDF-OOM1-RHCF](https://www.innodisk.com/en/products/camera/gmsl2/evdf-oom1-rhcf) | GMSL2 | 13MP Fixed Focus | Maxim MAX9295A | onsemi | onsemi AR1335 |
| [EV3F-ZSM1-RXCF](https://www.innodisk.com/en/products/camera/gmsl2) | GMSL2 | 3MP Fixed Focus, HDR LFM | Maxim MAX9295A | Sony | Sony ISX031 |

> Note: Camera driver patches, release packages for each BSP version, usage guides, and test reports are maintained in [iQ-Cam__manifest](https://github.com/InnoIPA/iQ-Cam__manifest). Refer there for the package that matches your BSP version, and to the [iQ-Cam test summary](https://github.com/InnoIPA/iQ-Cam__manifest/blob/main/doc/common/test_summary/) for test reports.