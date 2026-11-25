<!--
 Copyright (c) 2025 Innodisk Corp.

 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# iQ-Foundry Pose Model Benchmark

This benchmark compares [iQ-Foundry](https://github.com/InnoIPA/iQ-Foundry) pose-estimation model conversions and their measured performance on EXMP-Q911 (Qualcomm IQ-9075).

## Overview

This page compares the keypoint accuracy, deployment size, and on-device inference performance of the pose model combinations supported by [iQ-Foundry](https://github.com/InnoIPA/iQ-Foundry). The results help users select an appropriate model based on accuracy, inference latency, model size, runtime compatibility, and deployment requirements.

These results provide comparison data rather than a universal model ranking. Select a model according to the requirements of your application and deployment environment.

## Hardware and Benchmark Environment

### Hardware

| Item | Configuration |
| --- | --- |
| Target device | EXMP-Q911 (Qualcomm IQ-9075) |
| Inference accelerator | Qualcomm HTP/NPU |
| Power plan | 30 W (High Performance mode) |
| AI performance | 100 TOPS (Dense) |

### Benchmark Environment

| Item | Configuration |
| --- | --- |
| Dataset | [COCO 2017 validation dataset](https://cocodataset.org/#download) (person keypoints) |
| Evaluation subset | First 300 validation images |
| Evaluation images | 300 |
| Confidence threshold | 0.25 |
| NMS IoU threshold | 0.7 |
| Maximum detections | 300 |
| Reference model | Pretrained YOLO26n-pose model from [Ultralytics](https://docs.ultralytics.com/tasks/pose/) |

> [!NOTE]
> All mAP evaluations and inference-latency measurements used the first 300 images from the COCO 2017 validation dataset with the person keypoints annotations. The reference model was the pretrained YOLO26n-pose model obtained from Ultralytics, and all converted models were generated and evaluated using iQ-Foundry. Keypoint accuracy is scored by COCO Object Keypoint Similarity (OKS). Inference latency refers to model invocation latency rather than complete application pipeline latency.

## How to Read the Results (Metrics)

| Metric | Description | Preferred Direction |
| --- | --- | --- |
| Converted mAP@0.5 | Measured keypoint accuracy (OKS mAP at 0.5) after conversion. | Closer to the reference mAP@0.5 is better |
| mAP delta | Percentage change of mAP@0.5 relative to the original reference model. A negative value indicates lower measured accuracy after conversion; a positive value indicates a slightly higher result on this evaluation subset. | Closer to 0% is better |
| mAP@0.5:0.95 | Keypoint accuracy (OKS mAP averaged over 0.5 to 0.95), listed for comparison with the Ultralytics model table. | Closer to the reference value is better |
| Inference time | Average model invocation latency on the target device. | Lower is better |
| Model size | Storage size of the converted deployment model. | Lower is better |

## Benchmark Overview

![iQ-Foundry pose model accuracy and inference latency comparison](./fig/map_latency_barchart.png)

The chart provides a visual comparison of mAP change and model invocation latency across runtime and precision combinations.

> [!NOTE]
> **Benchmark conversion configuration:** YOLO26n-pose used the one-to-many (`O2M`) output head, and its quantized conversions used the MSE quantization scheme.

## Results

### LiteRT

| Model | Precision | mAP@0.5 (Reference) | mAP@0.5 (Converted) | mAP Delta (%) | mAP@0.5:0.95 (Reference) | mAP@0.5:0.95 (Converted) | Inference Time (ms) | Model Size (MB) |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| yolo26n-pose | FP32 | 0.8043 | 0.8046 | +0.04% | 0.5883 | 0.5853 | 8.882 | 11.8 |
| yolo26n-pose | INT8 | 0.8043 | 0.7959 | -1.04% | 0.5883 | 0.5477 | 5.023 | 3.3 |

### ONNX Runtime

| Model | Precision | mAP@0.5 (Reference) | mAP@0.5 (Converted) | mAP Delta (%) | mAP@0.5:0.95 (Reference) | mAP@0.5:0.95 (Converted) | Inference Time (ms) | Model Size (MB) |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| yolo26n-pose | FP32 | 0.8043 | 0.8045 | +0.03% | 0.5883 | 0.5852 | 9.677 | 10.4 |
| yolo26n-pose | W8A16 | 0.8043 | 0.8047 | +0.05% | 0.5883 | 0.5877 | 8.345 | 5.9 |

## Conclusion

There is no single best model for every deployment. Choose a model by considering the accuracy you can accept, the latency and model-size limits, and the runtime you deploy on.

- FP32 and ONNX W8A16 stay within 0.1% of the reference mAP@0.5.
- LiteRT INT8 is the smallest (3.3 MB) and fastest (5.0 ms, against 8.3 to 9.7 ms for the others). It costs 1.04% of mAP@0.5, and the stricter mAP@0.5:0.95 falls from 0.5883 to 0.5477 (-6.9%), so check it against your accuracy requirement.
- ONNX W8A16 keeps accuracy in this benchmark and is roughly half the size of ONNX FP32 (5.9 MB against 10.4 MB), with a slightly lower latency (8.3 ms against 9.7 ms).

For application-based recommendations, see the [iQ-Foundry Model Selection Guide](../../../tutorials/model-deploy/iqf-model-guide/README.md).

## Benchmark and Deploy Your Model

Use the following workflow to convert a supported pose model, evaluate its converted accuracy, deploy it to EXMP-Q911, and measure model invocation latency. Before starting, complete the iQ-Foundry host setup for your operating system:

- [Windows Host Guide](https://github.com/InnoIPA/iQ-Foundry/blob/main/Windows_host.md)
- [Ubuntu Host Guide](https://github.com/InnoIPA/iQ-Foundry/blob/main/Ubuntu_host.md)

The workflow has three stages:

1. Convert the model for the selected runtime and precision using `qc`.
2. Compare the reference and converted model accuracy using `eval`.
3. Deploy the converted model through ADB and measure invocation latency using `test`.

Replace the placeholder paths in the commands below with the paths for your model and evaluation data.

### Convert the Model for Deployment

Run the following command from the iQ-Foundry repository root to create a deployment model:

```bash
./docker/iqf run qc \
  --type yolov26 \
  --task pose \
  --runtime <litert|onnx> \
  --precision <fp32|int8|w8a16> \
  --model /path/to/yolo26n-pose.pt \
  --calib_dir /path/to/calibration_images
```

> Note: `--calib_dir` is required for quantized conversion. Omit `--calib_dir` for FP32 conversion.

Use one of the following runtime and precision supported combinations:

| Runtime | Precision |
| --- | --- |
| LiteRT | FP32 |
| LiteRT | INT8 |
| ONNX Runtime | FP32 |
| ONNX Runtime | W8A16 |

### Evaluate Conversion Accuracy

Compare the reference and converted model keypoint accuracy:

```bash
./docker/iqf run eval \
  --type yolov26 \
  --task pose \
  --runtime <litert|onnx> \
  --precision <fp32|int8|w8a16> \
  --annotations /path/to/annotations.json \
  --images /path/to/validation_images \
  --reference-model /path/to/yolo26n-pose.pt \
  --converted-model /path/to/converted_model \
  --conf 0.25 \
  --nms 0.7 \
  --max-det 300 \
  --max-images 300
```

The generated report contains the reference and converted keypoint mAP@0.5 and mAP@0.5:0.95. Use these results to assess the accuracy impact of conversion for your deployment.

### Deploy and Measure Inference Latency

Deploy the converted model to EXMP-Q911 through ADB and measure model invocation latency:

```bash
./docker/iqf run test \
  --type yolov26 \
  --task pose \
  --runtime <litert|onnx> \
  --precision <fp32|int8|w8a16> \
  --model /path/to/converted_model \
  --yaml /path/to/classes.yaml \
  --images /path/to/benchmark_images \
  --conf 0.25 \
  --nms 0.7 \
  --max-det 300 \
  --adb
```

The target EXMP-Q911 must be connected and visible through ADB. To compare your latency result with this page, `/path/to/benchmark_images` should contain the same first 300 COCO validation images used for the published benchmark.

At the end of the command output, record:

```text
avg_model_invoke_ms
```

This value represents the average model invocation latency.

> [!IMPORTANT]
> Use evaluation data that represents your deployment requirements. When comparing your results with this benchmark, use the same dataset, image subset, thresholds, device, power mode, runtime, and latency-measurement method. Results may vary with device software, runtime versions, model conversion settings, calibration data, thermal state, and application workload.
