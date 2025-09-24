<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# iQS-Streampipe
Streampipe is a C++ GStreamer and OpenCV-based multi-stream video processing pipeline. It supports real-time video input from UVC cameras or video files, and displays composite video output using a GStreamer compositor.

The set IDs are ordered on the screen from left to right, then from top to bottom

<br />
<div align="center"><img width="80%" height="80%" src="./fig/image0.png"></div>
<br />

<br />
<div align="center"><img width="80%" height="80%" src="./fig/gif0.gif"></div>
<br />

# What you need？

The demo can be run at following platform and BSP version

**[Future] BSP vs platform table**

1. At least 1 GB of free disk space
2. A monitor
3. At least one UVC camera
    - 1080p/30fps (1920x1080 pixels)
    - MJPEG compression format
    > Due to limited bandwidth, do not use more than 3 UVC cameras at once.
4. At least one MP4 video uses the H.264 codec.

# How to start?
    
```bash
git clone https://github.com/InnoIPA/iQ-Studio.git
cd iQ-Studio
./install.sh
```
# Run the demo    
1. Use iqs-launcher and autotag tools to automatically pull or build a compatible docker image.
    
    ```bash
    iqs-launcher --autotag iqs-streampipe
    ```
    
2. You will see in the screen.
    
    ![Recording 2025-08-13 at 15.22.58.gif](./fig/gif1.gif)