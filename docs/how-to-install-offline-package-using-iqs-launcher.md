<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# How to Install Offline Package Using iqs-launcher

## Introduction

At this point, it is assumed that you have already downloaded the iQ Studio GitHub repository and installed it on the platform.For details about how iQ Studio GitHub please refer to the [Quick Start section](../../../README.md) in the entry page.

You can refer to this tutorial to learn how to execute a docker image or IPK packages in offline mode.

Before entering an environment without internet access, you must pre-load the required packages (such as Docker images or IPK packages) onto the Qualcomm platform in order to perform offline installation."


## Offline Installation

The following describes two offline installation methods.
- Docker image
- IPK


### Step 1: Download Docker Images or IPK Packages on the Host(x86).

>Notice: This step must under the **internet connection**.

**A. Docker Images (.tar)** 

1. Install the [skopeo](https://github.com/containers/skopeo).

    Assuming you are using an x86 Ubuntu 24.04 computer, please refer to the following instructions for installation

    ```bash
    sudo apt-get -y update
    sudo apt-get -y install skopeo
    ```
    
    For other systems, please refer to the official [skopeo installation guide](https://github.com/containers/skopeo/blob/main/install.md)

2. Use the `skopeo copy` command to download an image from Docker hub and save it as a `.tar`.
    
    For example: if you need to download [iqs-vlm-demo](../../integrations/iqs-vlm/iqs-vlm.md) for BSP version `0.0.1`.

    1. You can search for the docker image for iQ-Studio in docker hub. Enter innodiskorg/<application name> at position 1 in the figure. Then, search the docker image version you want to download, as shown at position 2 in the figure.

        ![docker-hub-search](fig/docker-hub-search.png)
        
    2. Use the following command to download the Docker image.
        
        Usage
        ```bash
        skopeo copy \
        docker://docker.io/innodiskorg/<docker image name>:<version>\
        "docker-archive:<docker image name>.tar:innodiskorg/<docker image name>:<version>"
        ```

        Example

        ```bash
        skopeo copy \
        docker://docker.io/innodiskorg/iqs-vlm-demo:0.0.1 \
        "docker-archive:iqs-vlm-demo.tar:innodiskorg/iqs-vlm-demo:0.0.1"
        ``` 

    3. you will get a `.tar` file.

**B. IPK Packages (.ipk)**

1. Make sure you have the correct `.ipk` file that corresponds to your platform BSP version. 
    > Notice: Currently, these `.ipk` files are provided directly by Innodisk.


#### Step 2: Prepare to Put The File into the Platform (Qualcomm Platform)

1. Prepare a USB flash drive 
2. Put the downloaded `docker image.tar` or `demo.ipk`into it. Then insert it into the platform.
3. Use the command to find your USB device and mount it
    ```bash
    # on your Qualcomm platform
    lsblk
    ```
4. The following steps will be executed on your Qualcomm platform
5. You can see the following results (The results below will differ based on the hardware connected to the device.)
    ```bash
    # Taking my platform as an example, USB is located here

    |-sde53 259:37   0     4K  0 part 
    `-sde54 259:38   0     1M  0 part 
    sdf       8:80   0   200M  0 disk 
    sdg       8:96   0     1G  0 disk 
    sdh       8:112  0     1G  0 disk 
    sdi       8:128  1  14.5G  0 disk 
    `-sdi1    8:129  1  14.5G  0 part <- Your USB device
    ```
6. Create a folder to mount your USB. Assuming you are in your home directory.

    ```bash
    mkdir workspace/usb/
    mount /dev/sdi1 workspace/usb/
    ```

7. Copy the `docker image.tar` or `demo.ipk` in the USB to the folder under the iq studio
    
    - docker image 
        
        Usage

        ```bash
        cp workspace/usb/<docker image>.tar /path/to/iQ-Studio/binaries/docker-images/
        ```
        Example
        
        ```bash
        
        cp workspace/usb/iqs-vlm-demo.tar ~/iQ-Studio__confidential/binaries/docker-images/
        ```
    
    - IPK
        
        Usage

        ```bash
        cp workspace/usb/<demo>.ipk /path/to/iQ-Studio/binaries/ipk/
        ```
        Example
        
        ```bash
        
        cp workspace/usb/innoppe.ipk ~/iQ-Studio__confidential/binaries/ipk/
        ```
8. You must ensure that your Docker image or IPK package is placed in the following location.

    - Docker image: must under the path `iQ_studio/binaries/docker-images/`

        ```
        iQ-Studio__confidential/
        └── binaries/
            └── docker-images/
                └── iqs-vlm-demo.tar  <-- your .tar
        ```

    - IPK: must under the path `iQ_studio/binaries/ipk`

        ```
        iQ-Studio__confidential/
        └── binaries/
            └── ipk/
                └── your-package.ipk  <-- your .ipk
        ```


### Step 3: You can run our application in an environment without internet access. For details about the application, please refer to the [application guides](../README.md).