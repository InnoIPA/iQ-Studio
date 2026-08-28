# Changelogs

## v0.0.10
### Feat

- Reworked the Q911 Image Flashing Guide into a self-contained procedure covering host setup (`qdl` build and udev rules), EDL mode verification, image integrity check, the flashing command, and troubleshooting
- Added a Flashing from a Windows Host page covering `qdl.exe` setup and the Qualcomm USB Driver (QUD)

### Fixes

- Removed the outdated "Currently not supported" marking from the EXEC-Q911 and APEX-A100 rear-panel figures, as both DisplayPort outputs are supported

## v0.0.9
### Feat

- Added the iQ-Foundry Model Benchmark
- Added the iQ-Foundry Model Selection Guide

### Documentation

- Updated the YOLO26 Model Deploy tutorial for iQ-Foundry v0.0.3

## v0.0.8
### Feat

- Added a Qualcomm OTA Guide under Starting Guides, covering both Capsule and OSTree update flows
- Added landing pages for Starting Guides, Applications, SDKs, and Benchmarks so each category has a clear entry point
- Added `tools/compress_gifs.sh` for scanning and re-encoding oversized GIFs

### Refactor

- Restructured the entry README into three reader paths (run a demo, develop & customize, evaluate the platform) with a 30-Second Demo and category overviews
- Reworked `docs/how-to-use-iqs-launcher.md` (formerly `how-to-install-offline-package-using-iqs-launcher.md`) to cover online and offline modes side by side
- Split the Q911 Quick Start Guide into shared boot-up steps plus per-OS interaction pages for Yocto Linux and Ubuntu
- Simplified the GMSL and MIPI camera AVL pages so the full driver content lives in `iQ-Cam__manifest`
- Reworked the AVL root README to replace static figures with product-linked tables and source-aligned camera and peripheral fields

### Fixes

- Corrected the `iQ-ubuntu__manifest` URL and other broken cross-document links

### Chore

- Re-encoded oversized GIFs with gifski to shrink repository size
- Reorganized contributor guidance under `.agents/skills/` (replacing `IQS_FORMATTING.md` and `IQS_LITERACY.md`)

## v0.0.7
### Feat

- Added Model Deploy as a new iQ-Studio feature
- Updated AVL camera support for 8-channel validation, broader interface coverage, and newer system compatibility
- Added Q911 getting-started and platform guidance
- Added Model Deploy navigation to the entry README
- Update the Q911 HW image

### Fixes

- Fixed documentation paths and internal links
- Refined documentation content, wording, and structure

### Chore
- Remove all "$" for user easy to copy command

## v0.0.6
### Feat

- Added topic title to the entry page for improved navigation
- Added benchmark for perception AI benchmark between QCS9075 and nvidia AGX 
- Added benchmark for multi-stream inference on Jetson AGX and Qualcomm QCS9075
- Update streampipe docker for benchmark testing

### Fixes

- Disabled TTY support for docker run command


## v0.0.5
### Feat
- Support application can run both yocto and ubuntu
- Added a complete flashing image workflow, including step-by-step instructions and updated diagrams
- Introduced a flashing image guide and refined related sections for better onboarding
- Removed BSP version restriction and added custom tag support to improve deployment flexibility
- Updated application runtime to support both Yocto and Ubuntu environments
- Added OS detection to the run script to improve cross-platform behavior
- Enabled automatic installation of required packages on Ubuntu

### Fixes
- Fixed incorrect path in the offline download flow entry page

### Documentation
- Updated README with refined notes and minimum disk usage information
- Improved section titles and descriptions for better readability
- Aligned flashing, offline usage, and installation documentation into a clearer flow

## v0.0.4
### Feat
- Add documentation for OGenie SDK
- Add documentation for GMSL camera
- Add documentation for MIPI camera

## v0.0.3
### Feat
- Add YOLOv10n inference integration
- Add streampipe for multi-stream inference

### Docs
- Update VLM model demo GIF
- Add documentation for streampipe SDK and applications
- Refine phrasing, spacing, and formatting

## v0.0.2
### Doc
- Add some extra descriptions and fix the typos
### Fix
- Fix the metadata.json format

## v0.0.1
### Feat
- Add iQ Studio architecture documentation
- Add Q911 hardware introduction 
- Add VLM / YOLOv10n introduction and usage guide 
- Add iqs-launcher script and usage instructions 
- Add innoPPE benchmark content
