<!--
 Copyright (c) 2025 Innodisk Corp.

 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Docker Images for Offline Mode

This folder is empty by default. iQ-Studio does not ship Docker images in this repository.

Use it only for the offline flow, when the platform has no internet access. Place the Docker image archive (`.tar`) of the application here, and `iqs-launcher` loads it directly without contacting Docker Hub.

- The file name must match the application name, for example `iqs-vlm-demo.tar`.
- If you cannot access Docker Hub, contact Innodisk to obtain the `.tar`.

For how to download, transfer, and launch the image, see the [Offline Mode](../../docs/how-to-use-iqs-launcher.md#offline-mode) section of How to Use iqs-launcher.
