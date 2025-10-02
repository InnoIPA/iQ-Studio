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


# How to Use iQ Studio?

Before getting started, please refer to the [Starting Guides](./tutorials/starting-guides/) to boot up your platform. As with the Q911 series, please refer to the [EXMP-Q911 Starting Guide](./tutorials/starting-guides/q911/README.md).

iQ Studio enables users to run applications quickly. It supports both online and offline modes, ensuring that applications can run even without internet access. Currently, we provide two types of application packages—docker images and IPK packages—that can be executed with IQ Studio.

If you are using online mode (with internet access), you only need to install the iQ studio github repository on the platform and run our applications by following the tutorial commands. For usage instructions, please refer to the [Quick Start guide](./README.md#quick-start).

  <br />
  <div align="center"><img width="80%" height="80%" src="./docs/fig/iqs-online-flow.svg"></div>
  <br />

If you must use offline mode (without internet access), you need to first transfer the required packages and the iQ studio github repository to the platform before you can run the applications in an offline environment. For usage instructions, please refer to the [how to install offline package](./tutorials/starting-guides/iqs-launcher/how-to-install-offline-package-using-iqs-launcher.md).

  <br />
  <div align="center"><img width="80%" height="80%" src="./docs/fig/iqs-offline-flow.svg"></div>
  <br />

We verify the BSP version on the platform to ensure that applications run correctly. This check is automatically handled by `iqs-launcher`. However, it is important to confirm that the BSP version on your system matches the one specified in the tutorial before running any application.

## Quick Start

### Install iQ Studio

```bash
git clone https://github.com/InnoIPA/iQ-Studio.git
cd iQ-Studio
bash install.sh
```

### Run Application

For example, If you want to run the [iQ-VLM](./tutorials/integrations/iqs-vlm/iqs-vlm.md). You just need two command run the interative real-time demo.

Launch OGenie API server.
```bash
iqs-launcher --autotag iqs-ogenie
```
Real-Time Display of VLM Predictions on the Monitor.
```bash
iqs-launcher --autotag iqs-vlm-demo
```
This is provides a real-time display of VLM predictions, allowing you to quickly verify inference results.

The following screenshot shows the output captured using a UVC camera.

<br />
<div align="center"><img width="50%" height="50%" src="./docs/fig/iq-vlm-demo.gif"></div>
<br />

<p align="center">
  The GIF shows the output captured using a UVC camera.
</p>

For other applications, please refer to the [application section below](#application).

## Application

iQ Studio applications are grouped into categories based on functionality:


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
      <td>Quick-start guides for evertthing, include booting up guides and iqs-launcher guides.</td>
      <td>
        <ul>
          <li><a href="./tutorials/starting-guides/q911/README.md">Q911 quick start guide</a></li>
          <li><a href="./tutorials/starting-guides/iqs-launcher/README.md">iqs-launcher guide</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>AVL(Approved Vendor List)</td>
      <td>Provides guidance on verifying that the driver starts correctly on the system and quickly demonstrating the validated results.</td>
      <td>
        <ul>
          <li><a href="./tutorials/avl/avl/README.md">Approved vendor list</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>Applications</td>
      <td>Application-level examples focused on specific use cases and vertical scenarios.</td>
      <td>
        <ul>
          <li><a href="./tutorials/applications/iqs-vlm/README.md">iQS-VLM</a></li>
          <li><a href="./tutorials/applications/iqs-streampipe/README.md">iQS-Streampipe</a></li>
          <li><a href="./tutorials/applications/iqs-yolov10n/README.md">Yolov10n on EXMP-Q911</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>SDKs</td>
      <td>Documentation and examples on how to use the SDKs effectively.</td>
      <td>
        <ul>
          <li><a href="./tutorials/sdks/iqs-vlm/README.md">iQS-VLM SDK</a></li>
          <li><a href="./tutorials/sdks/iqs-streampipe/README.md">iQS-Streampipe SDK</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>Benchmarks</td>
      <td>Performance tests and comparisons across platforms.</td>
      <td>
        <ul>
          <li><a href="./benchmarks/innoppe/README.md">InnoPPE Benchmark between Jetson AGX and Qualcomm QCS9075</a></li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>

## Changelog

Please refer to the [Changelog](./docs/changelog.md) for all updates.

## License

This project is licensed under the MIT License. See [LICENSE](./LICENSE) for details.