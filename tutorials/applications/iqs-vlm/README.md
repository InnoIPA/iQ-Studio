<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# iQS-VLM

This demo showcases real-time inference using the vision-language model
**LLaVA-1.5-7B** on the platform with a live video stream from a UVC camera. It
utilizes `OGenie`, our API server that handles LLM/VLM inference requests, along
with `iq-VLM-DEMO`, which captures images from UVC cameras and displays the VLM
results on a monitor.

![demo gif](./fig/vlm-demo.gif)


# What do you need?

The demo can be run at following BSP version.
| APP version | Docker image | BSP version |
| :--- | :---- | :--- |
| 0.0.1 | iqs-vlm-demo | v0.0.1-Beta |
| 0.0.1 | iqs-ogenie | v0.0.1-Beta |
| 0.0.1 | iqs-vlm-demo | v0.0.2 |
| 0.0.1 | iqs-ogenie | v0.0.2 |

>Note: Our BSP version is the same as the docker tag.

1. At least 10 GB of free disk space
2. A monitor
3. A UVC camera
    - 1080p/30fps (1920x1080 pixels)
    - MJPEG compression format
    > Note: We have tried this demo with this [USB camera](https://www.innodisk.com/en/products/camera/usb-20/ev2u-ssm1-rlcf).


Please plug both devices—the UVC camera and the monitor—into the platform.


# How to start?

```bash
git clone https://github.com/InnoIPA/iQ-Studio.git
cd iQ-Studio
./install.sh
```

# Run the demo

## Launch `OGenie` API server

```bash
$ iqs-launcher --autotag iqs-ogenie
```

After starting `OGenie` server,  its URLs will be printed. 

```
OGenie Server can be reached by the following URLs:
http://127.0.0.1:22434
http://192.168.3.206:22434
http://172.17.0.1:22434
```

## Real-Time Display of VLM Predictions on the Monitor

```bash
$ iqs-launcher --autotag iqs-vlm-demo
```

Running this command will open a window showing live video from the UVC camera,
with the VLM response overlaid on the video. Press `q` to close the
window.

![demo image](./fig/vlm-demo.png)

# LLaVA-1.5-7B Performance

- Tokens per Second: 11

# iQS-VLM SDK

For advanced features and usage examples, visit this [page](../../sdks/iqs-vlm/README.md) to learn more.
