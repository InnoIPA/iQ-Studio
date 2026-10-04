<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->
# YOLOv10n INT8 Inference on GPU and NPU

![output.gif](./fig/gif0.gif)

>Note: The demo GIF may take some time to load. If it does not appear immediately, please wait.

Inference with the YOLOv10n model was conducted on both NVIDIA AGX Orin and Qualcomm EXMP-Q911 platforms, utilizing their respective GPU and NPU. A confidence threshold of 0.5 was applied, and the visual outputs were found to be highly comparable.

# Jetson AGX Orin

## Platform information

- RAM: 32GB
- TensorRT SDK Version: 8.5.2.2

### How to Use

We are using the [Ultralytics](https://docs.ultralytics.com/models/yolov10/) framework as a reference

- Convert model:
    
    ```bash
    yolo export model=yolov10n.pt format=engine int8=True simplify opset=13 workspace=16
    ```
    
- Inference:
    
    ```bash
    yolo predict model=yolov10n.engine source=<image or videos>
    ```
    

# EXMP-Q911

## Supported Versions

Pick the iQ-Studio version that matches your platform:

| Your platform | iQ-Studio version |
| :--- | :--- |
| BSP 2.5.x (QLI 2.0) | Latest (`main`) |
| BSP 2.3.x (QLI 1.8) | Tag `v0.0.10` or earlier |

- **Check BSP:** `cat /etc/innodisk/BSP-version`
- **Check QLI:** `uname -a`, then look for the `qli-<version>` field.

> Note: On BSP 2.3.x, run `git checkout v0.0.10` in the `iQ-Studio` directory before `./install.sh`. To return to the latest version, run `git checkout main`.

## Platform information

- RAM: 36GB
- Qnn SDK Version: 2.38

### How to Use

Use the iqs-launcher to start the application.

```bash
iqs-launcher --autotag iqs-yolov10n
```
If you want to change the video, please put your video in the current directory.

```bash
iqs-launcher --autotag iqs-yolov10n --other "-v <video_path>"
```
**Output location**: The predicted video will be saved in the `output` folder.

# Conclusion

In this case, **GPU** and **NPU** performance is almost identical, but the **NPU** has a lower cost and lower **power consumption**.
