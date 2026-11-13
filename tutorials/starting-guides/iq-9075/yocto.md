# Q911 — Yocto Linux Interaction Guide

This guide covers system interaction on Yocto Linux, the OS pre-flashed from [meta-iQ__manifest](https://github.com/InnoIPA/meta-iQ__manifest).

> Prerequisite: complete [Prepare Required Items](./README.md#step-1-prepare-required-items) and [Power On](./README.md#step-2-power-on) in the Q911 Quick Start Guide.

## Interact with the System

After the system boots, you can access the platform using one of the following methods:

- DisplayPort monitor
- SSH over Ethernet
- ADB over USB Type-C
- UART Debug Console

| Usage Method | Login Required |
| --- | --- |
| Desktop | No |
| SSH | Yes |
| ADB | No |
| UART | No |

### Default Credentials

```bash
Username: root
Password: oelinux123
```

### Interact with the System Using a DP Display

1. Connect the DP display and USB keyboard/mouse. Then power on the system.

  <div align="center">
  <table>
    <tr>
      <td align="center"  width="50%" valign="bottom">
        <img src="./fig/connect_dp_boot.png" style="max-height: 100%; max-width: 100%;">
      </td>
      <td align="center"  width="50%" valign="bottom">
        <img src="./fig/connect_dp_boot_a100.png" style="max-height: 100%; max-width: 100%;">
      </td>
    </tr>
    <tr>
      <td align="center">EXEC-Q911</td>
      <td align="center">APEX-A100</td>
    </tr>
  </table>
  </div>


2. After the device boots up, you should see the output displayed on the DisplayPort (DP) monitor. In Yocto Linux, you can click the icon in the upper-left corner to open the terminal.

     <p align="center">
      <img src="./fig/ycoto_desktop_icon.png" style="width:50%;">
    </p>

     <p align="center">
      <img src="./fig/yocto_desktop_teminal.png" style="width:50%;">
    </p>

### Interact with the System Using SSH over Ethernet

1. Connect an Ethernet cable and ensure that the device is reachable over the network. Then power on the system.

<div align="center">
  <table>
    <tr>
      <td align="center"  width="50%" valign="bottom">
        <img src="./fig/connect_eth_boot.png" style="max-height: 100%; max-width: 100%;">
      </td>
      <td align="center"  width="50%" valign="bottom">
        <img src="./fig/connect_eth_boot_a100.png" style="max-height: 100%; max-width: 100%;">
      </td>
    </tr>
    <tr>
      <td align="center">EXEC-Q911</td>
      <td align="center">APEX-A100</td>
    </tr>
  </table>
</div>

2. After the device boots up, you can access the device via SSH from any machine on the same network. Use the following command to connect to Yocto Linux:

    ```bash
    ssh root@<target device ip address>
    ```

     <p align="center">
      <img src="./fig/SSH_terminal.png" style="width:50%;">
    </p>

### Interact with the System Using ADB over USB Type-C

The USB Type-C port on both platforms supports `Flash / ADB`.

1. Connect the USB Type-C cable between the host and the device. Then power on the system.

  <div align="center">
  <table>
    <tr>
      <td align="center"  width="50%" valign="bottom">
        <img src="./fig/connect_adb_boot_flash.png" style="max-height: 100%; max-width: 100%;">
      </td>
      <td align="center"  width="50%" valign="bottom">
        <img src="./fig/connect_adb_boot_flash_a100.png" style="max-height: 100%; max-width: 100%;">
      </td>
    </tr>
    <tr>
      <td align="center">EXEC-Q911</td>
      <td align="center">APEX-A100</td>
    </tr>
  </table>
  </div>

2. After the device boots up, use the following commands on the host to verify the device connection and open an interactive shell.

    ```bash
    adb devices
    adb shell
    ```

3. You can run Linux commands from the `adb` shell. The example below checks the BSP version.

    ```bash
    adb shell
    sh-5.2# cat /etc/innodisk/BSP-version
    ```

    <p align="center">
      <img src="./fig/adb_usage_example.png" style="width:50%;">
    </p>

### Interact with the System Using UART Debug Console

> 💡 **Tip:** You can refer to the [Qualcomm guide on setting up a debug UART](https://docs.qualcomm.com/doc/80-70014-253/topic/ubuntu_host.html#set-up-debug-uart) for detailed instructions on how to connect using minicom.

1. Connect the USB-to-TTL serial adapter to the UART pins on the bottom side of the board. Then power on the system.


  <p align="center">
    <img src="./fig/debug_port_pin.png" style="width:50%;">
  </p>

  > 💡 **Tip:** Set your serial terminal to 115200 baud, 8 data bits, no parity, 1 stop bit, no flow control

2. After the device boots up, you will see a screen similar to the one shown below.

  <p align="center">
    <img src="./fig/debug_port_view.png" style="width:50%;">
  </p>