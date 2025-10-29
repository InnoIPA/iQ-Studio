<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->
# YOLOv10n on EXMP-Q911

![output.gif](./fig/gif0.gif)

>Note: The demo GIF may take some time to load. If it does not appear immediately, please wait.

Inference with the YOLOv10n model was conducted on both NVIDIA AGX ORIN and Qualcomm EXMP-Q911 platforms, utilizing their respective GPU and NPU. A confidence threshold of 0.5 was applied, and the visual outputs were found to be highly comparable.

# Jetson AGX ORIN

## Platform information

- RAM: 32GB
- TensorRT SDK Version: 8.5.2.2

### How to demo the model?

We are using the [Ultralytics](https://docs.ultralytics.com/models/yolov10/) framework as a reference

- Convert model:
    
    ```bash
    $ yolo export model=yolov10n.pt format=engine int8=True simplify opset=13 workspace=16
    ```
    
- Inference:
    
    ```bash
    $ yolo predict model=yolov10n.engine source=<image or videos>
    ```
    

# EXMP-Q911

## Platform information

- RAM: 36GB
- Qnn SDK Version: 2.29

The demo can be run at following platform and BSP version.
| APP version | Docker image | BSP version |
| :--- | :---- | :--- |
| 1.0.0 | iqs-yolov10n | v0.0.2 |

>Note: Our BSP version is the same as the docker tag.

### How to demo the model?

Use the iqs-launcher to start the application.

```bash
$ iqs-launcher --autotag iqs-yolov10n
```
If you want to change the video, please put your video in the current directory.

```bash
$ iqs-launcher --autotag iqs-yolov10n --other "-v <video_path>"
```
**Output location**: The predicted video will be saved in the `output` folder.

# Conclusion

In this case, **GPU** and **NPU** performance is almost identical, but the **NPU** has a lower cost and lower **power consumption**.