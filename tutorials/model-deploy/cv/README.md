# Model Deploy: Computer Vision Tutorials

These tutorials follow the [iQ-Foundry](https://github.com/InnoIPA/iQ-Foundry) workflow for EXMP-Q911 (Qualcomm QCS9075). Each one walks through the same three modes (`qc`, `eval`, `test`) for one task: convert a model, check its accuracy, and run it on the target through ADB.

## Tutorials

| Task | Model | Accuracy check in `eval` | Tutorial |
| --- | --- | --- | --- |
| Object detection | YOLOv10, YOLOv11, YOLO26 | `mAP@0.5` | [detect](./detect/README.md) |
| Pose estimation | YOLO26 | Keypoint `mAP@0.5` | [pose](./pose/README.md) |
| Instance segmentation | YOLO26 | Mask `mAP@0.5` | [segment](./segment/README.md) |
| Image classification | ResNet50 | `top-1` and `top-5` accuracy | [classify](./classify/README.md) |

Start with [detect](./detect/README.md) if you are new to the flow. The other tutorials follow the same steps and differ only in the `--task` option, the data that `eval` and `test` need, and the output folders.

## Related Pages

- [Model Selection Guide](../iqf-model-guide/README.md): choose a model configuration for your accuracy, speed, size, and runtime needs.
- [iQ-Foundry Model Benchmark](../../../benchmarks/iqf-models/README.md): accuracy, model size, and inference latency results for each task.
