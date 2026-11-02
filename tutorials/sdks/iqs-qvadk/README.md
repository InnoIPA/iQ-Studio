<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# iQS-QVADK: Applications

Please refer to the `tutorials/applications/iqs-qvadk` to learn how to deploy and run [iqs-qvadk](../../applications/iqs-qvadk/README.md).

iqs-qvadk runs **PPE** (default) and **Defect detection**, and PPE can also take live input from a UVC or GMSL camera. This page shows how to switch between them. DMS in the preview below is for demonstration only.

<br />
<div align="center"><img width="80%" height="80%" src="./fig/architecture.svg"></div>
<br />

>Note: The demo GIF may take some time to load. If it does not appear immediately, please wait.

| Application | Channels | Models | Classes | Description | Preview |
| --- | :---: | --- | --- | --- | :---: |
| PPE | 9 | yolo26n, scrfd | 5 (yolo26n), 1 (scrfd) | Runs PPE and ROI person detection on 9 streams. With face mosaic enabled, 18 models run at the same time. | <img src="./fig/ppe_thumb.png" width="240"> |
| Defect detection | 6 | yolov10n | 1 | Runs one independent YOLO model on each of 6 streams to detect screw defects on a production line. | <img src="./fig/dd_thumb.png" width="240"> |
| DMS | 3 | scrfd, landmark, resnet18, resnet50 | 1 (scrfd), 1 (landmark), 2 and 3 (resnet18), 5 (resnet50) | Chains face, gaze, hand and body models on each of 3 driver streams (5 models in total) and shows a warning on high-risk behavior. | <img src="./fig/dms_thumb.png" width="240"> |

> Note: Only PPE and Defect detection can be run with this image. DMS is for demonstration only; see [Other applications](#other-applications-preview-only).

## How to switch and run an application

Close the running application before starting another one.

### PPE (default)

```bash
iqs-launcher --autotag iqs-qvadk
```

![PPE](./fig/ppe.gif)

### Defect detection

Defect detection is not the default application. Use `--other` to load its config file.

```bash
iqs-launcher --autotag iqs-qvadk --other "-c /app/configs/adb_config/videos/config_dd.json"
```

To go back to PPE, close the running application and run the PPE command again.

![Defect detection](./fig/dd.gif)

### PPE with camera

PPE can also take live input from a camera. The camera configs are in this directory, which `iqs-launcher` mounts into the container as `/workspace`, so run the commands from the iqs-qvadk directory. The camera feeds the first stream; the other streams keep playing videos.

#### UVC camera

At least one UVC camera.

- 1080p/30fps (1920x1080 pixels)
- MJPEG compression format
- For example, this Innodisk [USB camera](https://www.innodisk.com/en/products/camera/usb-20/ev2u-ssm1-rlcf).

```bash
cd tutorials/sdks/iqs-qvadk/
iqs-launcher --autotag iqs-qvadk --other "-c /workspace/configs/uvc/config_ppe_uvc.json"
```

#### GMSL camera

At least one GMSL camera.

- Download the camera driver package for your module (for the EV3F-ZSM1, `ev3f_zsm1_pp19`) from the [iQ-Cam release page](https://github.com/InnoIPA/iQ-Cam__manifest/tree/main/release).
- To install and use a GMSL camera, please refer to the [iQ-Cam GMSL Camera Guide](https://github.com/InnoIPA/iQ-Cam__manifest/blob/v3.0.0/doc/common/gmsl.md).

> Note: This demo has only been tested with the EV3F-ZSM1 camera.

```bash
cd tutorials/sdks/iqs-qvadk/
iqs-launcher --autotag iqs-qvadk --other "-c /workspace/configs/gmsl/config_ppe_gmsl.json"
```

![PPE with camera](./fig/ppe_camera.gif)

## Other applications (preview only)

The following application is shown for demonstration. It is not available in this image.

### DMS

![DMS](./fig/dms.gif)
