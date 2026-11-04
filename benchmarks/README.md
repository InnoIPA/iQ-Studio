<!--
 Copyright (c) 2025 Innodisk Corp.

 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Benchmarks

Reproducible performance measurements on iQ-Studio platforms. Each report includes scripts, configuration, and runtime environment.

## Overview

Measured numbers for evaluators and integrators — pick the workload closest to yours and read the report. To reproduce on your own hardware, start at [Starting Guides](../tutorials/starting-guides/README.md) and run the matching [Application](../tutorials/applications/README.md).

| Benchmark | Workload |
| --- | --- |
| [InnoPPE Benchmark](./innoppe/README.md) | Multi-stream YOLO inference (10 concurrent streams). |
| [iQS-Streampipe Benchmark](./iqs-streampipe/README.md) | Multi-stream generic inference pipeline scaling. |
| [Multi-stream Scaling Benchmark](./multistream/README.md) | Multi-stream inference scaling at 720p, 1080p, 2K, and 4K on EXEC-Q911. |
| [Perception Model Benchmark](./perception_model/README.md) | Computer vision perception model suite. |
| [iQ-Foundry Model Benchmark](./iqf-models/README.md) | Accuracy, size, and inference latency for [iQ-Foundry](https://github.com/InnoIPA/iQ-Foundry) models. |
