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
    yolo export model=yolov10n.pt format=engine int8=True simplify opset=13 workspace=16
    ```
    
- Inference:
    
    ```bash
    yolo predict model=yolov10s.engine source=<image or videos>
    ```
    

# EXMP-Q911

## Platform information

- RAM: 36GB
- Qnn SDK Version: 2.29

### How to demo the model?

Our model is different from [Qualcomm AI Hub](https://aihub.qualcomm.com/models/yolov10_det) .

Model download here: [yolov10n_full_integer_quant.tflite](./model/yolov10n_full_integer_quant.tflite)

# Conclusion

In this case, **GPU** and **NPU** performance is almost identical, but the **NPU** has a lower cost and lower **power consumption**.