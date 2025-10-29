<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# InnoPPE Benchmark between Jetson AGX and Qualcomm QCS9075

We conducted a performance comparison between the NVIDIA Jetson AGX Orin and
the [Qualcomm QCS9075](https://www.qualcomm.com/developer/hardware/qualcomm-iq-9075-evaluation-kit-evk) by running the same application on both platforms,
focusing on their ability to handle multiple **video streams** and **YOLO model
inference**.

> Note: Testing for EXMP-Q911 will be included in future updates.

- How was the test conducted?

  - We used [InnoPPE][InnoPPE] as the main application for evaluation. 
      - innoPPE is a multi-channel safety monitoring system that can run across different streams simultaneously to monitor multiple locations in real time.

         <br />
         <div align="left"><img width="50%" height="50%" src="./fig/innoppe.png"></div>
         <br />   

  - InnoPPE was configured to process 10 video streams simultaneous(1 live UVC
  camera and 9 locally stored video files).

  - Multiple AI inference were executed concurrently to perform simultaneous
  recognition tasks.

## Hardware

### Computing Platforms

| **Platform**          | **AIB-MX13-1-A1**                                               | **IQ-9075-EVK**                                  |
|:----------------------|:-----------------------------------------------------------|:------------------------------------------------------|
| **SoM / SoC**         | Jetson AGX Orin Developer Kit - Jetpack 5.1.2 [L4T 35.4.1] | Qualcomm QCS9075                                      |
| **Power consumption** | 35 W                                                       | 20 W                                                  |
| **AI Accelerator**    | GPU                                                        | Single DSP                                            |
| **AI Runtime**        | TensorRT                                                   | TensorFlow Lite                                       |
| **AI Performance**    | 200 TOPS (Sparse)                                          | 100 TOPS (Dense)                                      |
| **AI Model**          | ppes.nvidia.73.8.0.1.pmodel                                | ppes.qnn.computex.20.0.1.pmodel                       |
| **AI Model Arch.**    | yolov10n - int8 (TRT)                                      | yolov10n - int8 (QNN)                                 |
| **Linux Kernel**      | 5.10.120-tegra                                             | 6.6.90-qli-1.5-ver.1.1-04509-gc4b8666c9a55            |
| **Input Setting**     | 10 Channels, 1080p, 30 FPS (single UVC Cam, 9 Videos)      | 10 Channels, 1080p, 30 FPS (single UVC Cam, 9 Videos) |

### UVC Cameras

| Model                            | Resolution       | Frame Rate | Codec |
|:---------------------------------|:-----------------|:-----------|:------|
| [EV2U-SSM1-RLCF][EV2U-SSM1-RLCF] | 1920x1080 pixels | 30 FPS     | MJPEG |


### Videos

| File Type | Resolution       | Frame Rate | Codec | Bitrate   | File Size |
|:----------|:-----------------|:-----------|:------|:----------|:----------|
| MP4       | 1920x1080 pixels | 30 FPS     | H.264 | 3522 kbps | 11.9 MB   |

## Benchmark results

![benchmark_results](./fig/results.svg)

We compared several performance metrics between the IQ-9075-EVK and AIB-MX13-1-A1 while
running 10 InnoPPE channels, measuring FPS on the channel with a UVC camera
input, and observed that the FPS on the IQ-9075-EVK was approximately three times
higher than on the AIB-MX13-1-A1.

## Conclusion

Under the 10 channel(single UVC Cam, 9 Videos), the **IQ-9075-EVK** achieves per-channel performance (FPS) is 212.5% higher than the **AIB-MX13-1-A1**.


# Appendix: How do I execute the benchmark?

## What do you need?

1. Three python
   [scripts](./scripts): `system_monitor.py`, `draw_csv.py` and `print_mean.py`

2. `requirements.txt` for creating python virtual environment.

### Start the benchmark

1. Run `system_monitor.py` to start monitoring system metrics.

   ```bash
   $ python3 system_monitor.py
   ```

   The data will be continuously written to `test.csv`. Press **Ctrl + C** to stop monitoring.

2. After obtaining `test.csv`, run `draw_csv.py` to generate charts.

   ```bash
   $ python3 draw_csv.py
   ```

   The resulting charts will be saved in the `report/` directory.

   <img
      src="./fig/system_usage_cpu_separate.png"
      alt="Descrisystem_usage_cpu_separate_example"
      width="400"
   />

3. To calculate the average values of the collected metrics, run `print_mean.py`.

   ```bash
   $ python3 print_mean.py
   ```

   ```
   CPU Usage Average: 41.32%
   CPU Temperature Average: 43.74°C
   Memory Usage Average: 27.53%
   Disk Usage Average: 94.96%
   Network Usage Average: 0.02 MB/s
   ```

[EV2U-SSM1-RLCF]: <https://www.innodisk.com/en/products/camera/usb-20/ev2u-ssm1-rlcf>
[InnoPPE]: <https://www.innodisk.com/cht/application-scenarios/innoppe-recognition-solution>
<!---
    vim:nowrap
-->
