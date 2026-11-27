<!--
 Copyright (c) 2025 Innodisk Corp.

 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# iQ-Foundry Model Benchmark

This benchmark compares [iQ-Foundry](https://github.com/InnoIPA/iQ-Foundry) model conversions and their measured performance on EXMP-Q911 (Qualcomm IQ-9075). Each task has its own page with the same structure: accuracy against the original model, on-device inference latency, and model size for each runtime and precision.

## Tasks

| Task | Model | Accuracy metric | Page |
| --- | --- | --- | --- |
| Object detection | YOLOv10n, YOLOv11n, YOLOv26n | mAP@0.5 | [Detection](./detect/README.md) |
| Pose estimation | YOLO26n-pose | Keypoint mAP@0.5 | [Pose](./pose/README.md) |
| Instance segmentation | YOLO26n-seg | Mask mAP@0.5 | [Segmentation](./segment/README.md) |
| Image classification | ResNet50 | Top-1 accuracy | [Classification](./classify/README.md) |

## Common Setup

| Item | Configuration |
| --- | --- |
| Target device | EXMP-Q911 (Qualcomm IQ-9075) |
| Inference accelerator | Qualcomm HTP/NPU |
| Power plan | 30 W (High Performance mode) |
| Evaluation images | 300 per task |
| Latency | Average model invocation latency (`avg_model_invoke_ms`) |

> [!NOTE]
> Inference latency refers to model invocation latency rather than complete application pipeline latency. Results are comparison data, not a universal model ranking; each page lists its own dataset, thresholds, and conversion settings.

For application-based recommendations, see the [iQ-Foundry Model Selection Guide](../../tutorials/model-deploy/iqf-model-guide/README.md).
