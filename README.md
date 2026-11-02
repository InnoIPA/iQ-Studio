<!--
 Copyright (c) 2025 Innodisk Corp.

 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->
# iQ Studio

  <br />
  <div align="center"><img width="30%" height="30%" src="./docs/fig/iq-studio-logo.png"></div>
  <br />

  <h1 align="center"><em><strong>Show Performance, Spark Imagination.</strong></em></h1>

  <h3 align="center">It helps users quickly understand, explore, and prototype ideas by showcasing the platform’s performance and capabilities—inspiring innovation through hands-on experience.</h3>

> [!NOTE]
> iQ-Studio is suitable for a range of products developed based on the [Innodisk Qualcomm Dragonwing SoC](https://www.innodisk.com/en/news/innodisk-unveils-ai-on-dragonwing-computing-series).

# Pick Your Path

Three common starting points. Pick the one that matches your goal today; you can always come back for another.

> 💡 **Just received hardware?** Start at [Starting Guides](./tutorials/starting-guides/README.md) to boot your device first.

| 🚀 Run a demo | 🛠 Develop & customize | 📊 Evaluate the platform |
| --- | --- | --- |
| **For FAEs and evaluators.** See an AI inference demo running on the hardware in under ten minutes. | **For application developers and ML engineers.** Swap models, change inputs, or deploy your own trained model. | **For PMs and integrators.** Review measured performance on real workloads and how iQ-Studio fits the platform stack. |
| Jump to [30-Second Demo](#30-second-demo) below, then explore [Applications](./tutorials/applications/README.md). | Start at [SDKs](./tutorials/sdks/README.md) to customize, or [Model Deploy](./tutorials/model-deploy/README.md) to bring your own model. | See [Benchmarks](./benchmarks/README.md) — real-world numbers for multi-stream YOLO, CV models, and perception workloads on QCS9075. |

# 30-Second Demo

If iQ-Studio is already installed on the platform (see [Quick Start](#quick-start) below), two commands are enough to see a vision-language model running on a live UVC Camera feed.

Launch the OGenie API server:

```bash
iqs-launcher --autotag iqs-ogenie
```

Display VLM predictions on the monitor in real time:

```bash
iqs-launcher --autotag iqs-vlm-demo
```

<br />
<div align="center"><img width="100%" height="100%" src="./tutorials/applications/iqs-vlm/fig/vlm-demo.gif"></div>
<br />

For other applications and the launch commands behind them, see [Applications](./tutorials/applications/README.md).

# Performance

Reproducible benchmarks for multi-stream YOLO, generic streaming pipelines, and perception models on Qualcomm QCS9075.

See [Benchmarks](./benchmarks/README.md) for the full reports.

# Core Software Stack & Architecture

iQ-Studio is built upon a robust edge AI software stack, bridging the gap between hardware and high-level applications:

<br />
<div align="center"><img width="80%" height="80%" src="./docs/fig/ai_on_dragonwing_sw_stack.png"></div>
<br />

- **Hardware & Firmware**: [Qualcomm Dragonwing QCS9075 SoC](https://www.innodisk.com/en/products/computing/qualcomm-solution/exmp-q911) and low-level firmware.
- **Kernel Space**: Powered by [Qualcomm Linux](https://www.qualcomm.com/developer/software/qualcomm-linux), integrated with our custom [Inno DTB/drivers and Yocto environments](https://github.com/InnoIPA/meta-iQ__manifest).
- **User Space**: Seamlessly supports 3rd-party LLM SDKs, device management ([iCAP](https://www.innodisk.com/en/products/software-icap)), and inno AVL. At the very top sits the **[iQS-App layer](./README.md#explore-documentation--resources)** (VLM, Streampipe, YOLO, OGenie).

### Qualcomm Linux (QLI) Version Mapping

Our architecture evolves alongside the [Qualcomm Linux Roadmap](https://www.qualcomm.com/developer/software/qualcomm-linux), ensuring alignment with the latest kernel and Yocto Project releases:

| Linux Kernel | Yocto Project | Qualcomm Linux (QLI) Release |
| :--- | :--- | :--- |
| **6.6 LTS** | 4.0 Kirkstone | QLI 1.x |
| **6.6 LTS** | 5.0 Scarthgap | QLI 1.x |
| **6.18 LTS** | Wrynose (Master) | QLI 2.x |

<br />
<div align="center"><img width="80%" height="80%" src="./docs/fig/qcl_roadmap.png"></div>
<br />

We ensure a continuous and stable pipeline—from upstream Linux/Yocto projects down to the optimized downstream drivers—unlocking peak performance for edge AI workloads.

Our BSP foundation is published through [InnoIPA/meta-iQ__manifest](https://github.com/InnoIPA/meta-iQ__manifest), providing a reproducible Qualcomm Yocto-based system base for EXMP-Q911 and the QCS9075 iQ-9075 EVK. iQ-Studio builds on this foundation with application demos, AVL checks, benchmarks, and `iqs-launcher` compatibility handling, helping users evaluate and deploy edge AI workloads with greater confidence.

<br />
<div align="center"><img width="80%" height="80%" src="./docs/fig/sw_development_pipeline.png"></div>
<br />

We also provide integrated and supplied [Ubuntu images](https://ubuntu.com/download/qualcomm-iot#evaluation-kit) for development.

> Note: To keep all IO functions working correctly, use the Innodisk-provided Ubuntu image. See [InnoIPA/iQ-ubuntu__manifest](https://github.com/InnoIPA/iQ-ubuntu__manifest) for the available image versions. The official Ubuntu image from Qualcomm can boot on the platform but does not guarantee full IO support.

# How to Use iqs-launcher

`iqs-launcher` is the execution entry point for every application in iQ-Studio. It checks the platform BSP version, then pulls (online) or loads (offline) the matching Docker image or IPK package.

Both online and offline modes — including pre-staging packages for an air-gapped platform — are covered in [docs/how-to-use-iqs-launcher.md](./docs/how-to-use-iqs-launcher.md).

Before getting started, refer to the [Starting Guides](./tutorials/starting-guides/README.md) to boot up your platform. For the Q911 series, see the [EXMP-Q911 Starting Guide](./tutorials/starting-guides/q911/README.md).

# Quick Start

## Install iQ Studio

```bash
git clone https://github.com/InnoIPA/iQ-Studio.git
cd iQ-Studio
./install.sh
```
> Note: If you are using Ubuntu, please log in again after installation.

# Explore Documentation & Resources

iQ Studio resources are grouped into categories based on functionality:


<table>
  <col style="width: 30%">
  <col style="width: 30%">
  <col style="width: 40%">
  <thead>
    <tr>
      <th>Categories</th>
      <th>Description</th>
      <th>Topic</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Starting Guides</td>
      <td>Quick-start guides for everything.</td>
      <td>
        <ul>
          <li><a href="./tutorials/starting-guides/README.md">Starting Guides Overview</a></li>
          <li><a href="./tutorials/starting-guides/q911/README.md">Q911 Quick Start Guide</a></li>
          <li><a href="./tutorials/starting-guides/flash-image/README.md">Q911 Image Flashing Guide</a></li>
          <li><a href="./tutorials/starting-guides/ota/README.md">Qualcomm OTA Guide</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>AVL(Approved Vendor List)</td>
      <td>Provides guidance on verifying that the driver starts correctly on the system and quickly demonstrating the validated results.</td>
      <td>
        <ul>
          <li><a href="./tutorials/avl/README.md">Approved Vendor List</a></li>
          <li><a href="./tutorials/avl/gmsl-camera/README.md">GMSL Camera</a></li>
          <li><a href="./tutorials/avl/mipi-camera/README.md">MIPI Camera</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>Applications</td>
      <td>Application-level examples focused on specific use cases and vertical scenarios.</td>
      <td>
        <ul>
          <li><a href="./tutorials/applications/README.md">Applications Overview</a></li>
          <li><a href="./tutorials/applications/iqs-vlm/README.md">iQS-VLM</a></li>
          <li><a href="./tutorials/applications/iqs-streampipe/README.md">iQS-Streampipe</a></li>
          <li><a href="./tutorials/applications/iqs-yolov10n/README.md">YOLOv10n INT8 Inference on GPU and NPU</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>Model Deploy</td>
      <td>End-to-end guides for turning trained AI models into target-ready artifacts, covering quantization, conversion, quality validation, and on-device inference.</td>
      <td>
        <ul>
          <li><a href="./tutorials/model-deploy/README.md">Model Deploy Overview</a></li>
          <li><a href="./tutorials/model-deploy/cv/yolo26/README.md">Model Deploy: How to Convert, Optimize, and Perform Inference with YOLO26 Models</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>SDKs</td>
      <td>Documentation and examples on how to use the SDKs effectively.</td>
      <td>
        <ul>
          <li><a href="./tutorials/sdks/README.md">SDKs Overview</a></li>
          <li><a href="./tutorials/sdks/iqs-vlm/README.md">iQS-VLM: How to Interact with the OGenie Server through Open WebUI</a></li>
          <li><a href="./tutorials/sdks/iqs-streampipe/README.md">iQS-Streampipe: How to Change the Custom Model and Video Source</a></li>
          <li><a href="./tutorials/sdks/iqs-ogenie/README.md">iQS-OGenie: Run Your Own Demo with OGenie Server</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>Benchmarks</td>
      <td>Performance tests and comparisons across platforms.</td>
      <td>
        <ul>
          <li><a href="./benchmarks/README.md">Benchmarks Overview</a></li>
          <li><a href="./benchmarks/innoppe/README.md">InnoPPE Benchmark</a></li>
          <li><a href="./benchmarks/iqs-streampipe/README.md">Multi-stream Inference Status</a></li>
          <li><a href="./benchmarks/multistream/README.md">Multi-stream Scaling Across Resolutions</a></li>
          <li><a href="./benchmarks/perception_model/README.md">Perception AI Benchmark</a></li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>

# Related Repositories

iQ-Studio integrates with several sibling repositories. Each owns a specific layer of the platform stack.

- [InnoIPA/meta-iQ__manifest](https://github.com/InnoIPA/meta-iQ__manifest) — Yocto-based BSP baseline for the platform.
- [InnoIPA/iQ-Cam__manifest](https://github.com/InnoIPA/iQ-Cam__manifest) — Camera driver patches consumed by the AVL tutorials.
- [InnoIPA/iQ-ubuntu__manifest](https://github.com/InnoIPA/iQ-ubuntu__manifest) — Reference for Innodisk-provided Ubuntu image versions.
- [InnoIPA/iQ-Foundry](https://github.com/InnoIPA/iQ-Foundry) — End-to-end model quantization and on-device validation for custom models.

# Changelog

Please refer to the [Changelog](./docs/changelog.md) for all updates.

# License

This project is licensed under the MIT License. See [LICENSE](./LICENSE) for details.
