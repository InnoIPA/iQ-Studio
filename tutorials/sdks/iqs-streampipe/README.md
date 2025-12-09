<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# iQS-Streampipe: How to Change the Custom Model and Video Source

Please refer to the `tutorial/applications/iqs-streampipe`to learn how to run [iqs-streampipe](../../applications/iqs-streampipe/README.md).

In this section, we describe how to use custom models and video inputs with iqs-streampipe. 

# What you need？

1. At least one UVC camera
    - 1080p/30fps (1920x1080 pixels)
    - MJPEG compression format
    > Due to limited bandwidth, do not use more than 3 UVC cameras at once.
2. At least one MP4 video uses the H.264 codec.

## How to modify the content displayed, please refer to the `config.json` file in the current directory.

1. Navigate to the iqs-streampipe directory.and check the file in your current directory.
    
    ```bash
    $ cd tutorials/sdks/iqs-streampipe/
    ```
    
    <br />
    <div align="center"><img width="35%" height="35%" src="./fig/image1.png"></div>
    <br />
    
2. Open the `config.json` file in the current directory
    
    To open and edit the `config.json` file.(default parameter)
    
    ```bash
    $ vim config.json
    ```
    <br />
    <div align="center"><img width="80%" height="80%" src="./fig/image2.png"></div>
    <br />
    
3. Modify `config.json`. We have changed the video under `id: 1` to `coco_detect.mp4`.You may replace coco_detect.mp4 with your own video file if desired.
   
    NOTE : This config is not the default config in the Docker container.

    Enter the Relativate Path into the config file.

    <br />
    <div align="center"><img width="80%" height="80%" src="./fig/image3.png"></div>
    <br />
    
4. After you finish modifying.
    
    save and close the `config.json`.
    
    ```bash
    $ :wq
    ```
    
5. Run the iqs-launcher 

    NOTE : You must add the `--other "-c config.json"` option to change the videos..
    
    ```bash
    $ iqs-launcher --autotag iqs-streampipe --other "-c config.json"
    ```
    
6. Change the display of ID 1 to the specified view.
    >Note: The demo GIF may take some time to load. If it does not appear immediately, please wait.

    <br />
    <div align="center"><img width="80%" height="80%" src="./fig/gif2.gif"></div>
    <br />

## How to use a UVC camera to capture video frames for real-time prediction.
>Note: The demo GIF may take some time to load. If it does not appear immediately, please wait.

- When a UVC camera's USB plug is connected to the platform's USB port, the video prediction will automatically switch to and display the real-time prediction results from the UVC camera feed.
- When multiple cameras are plugged in, the results will be replaced based on channels, starting with channel 0, then channel 1, and so on.

<br />
<div align="center"><img width="80%" height="80%" src="./fig/gif0.gif"></div>
<br />

> Notice: Due to limited bandwidth, using more than 3 UVC cameras will cause video lag.if you use more than 4 camera will cause the unexpected bug.

# Known Issue
The current Qualcomm codec driver may under certain conditions, cause the system to restart unexpectedly. If this occurs, re-run the process to continue.