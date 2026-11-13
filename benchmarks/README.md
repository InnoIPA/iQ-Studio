<!--
 Copyright (c) 2025 Innodisk Corp.

 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Benchmarks

Reproducible performance measurements on iQ-Studio platforms. Each report includes scripts, configuration, and runtime environment.

## Overview

Measured numbers for evaluators and integrators — pick the workload closest to yours and read the report. To reproduce on your own hardware, start at [Starting Guides](../tutorials/starting-guides/README.md) and run the matching [Application](../tutorials/applications/README.md).

| Platform | Category | Topic | Workload |
| --- | --- | --- | --- |
| IQ-9075 | Model | [Perception AI Benchmark](./iq-9075/model/perception_model/README.md) | Computer vision perception model suite, compared with NVIDIA Jetson AGX Orin. |
| IQ-9075 | Model | [iQ-Foundry Model Benchmark](./iqf-models/README.md) | Accuracy, size, and inference latency of iQ-Foundry models. |
| IQ-9075 | Multi-stream | [iQS-Streampipe Multi-stream Inference](./iq-9075/multi-stream/iqs-streampipe/README.md) | Scaling from 1 to 16 channels at 1080p, compared with NVIDIA Jetson AGX Orin. |
| IQ-9075 | Multi-stream | [iQS-QVADK Multi-stream Scaling](./iq-9075/multi-stream/multistream/README.md) | Scaling at 720p, 1080p, 2K, and 4K on EXEC-Q911. |
| IQ-8275 | Multi-stream | [iQS-Streampipe Multi-stream Inference](./iq-8275/multi-stream/iqs-streampipe/README.md) | Scaling at 720p, 1080p, 2K, and 4K, compared with NVIDIA Jetson Orin NX. |
