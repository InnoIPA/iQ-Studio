<!--
 Copyright (c) 2025 Innodisk Corp.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->
# iQ-Studio Agent Entry Guide

This document is the durable entrypoint for AI agents and human developers working on iQ-Studio. It explains the project intent, routes work to the right repo skill, and defines verification expectations.

## 0. Skill Routing

Use the focused skills in `.agents/skills/` instead of duplicating rules here:

- `iq-studio-agent`: general iQ-Studio repository work, launcher changes, tutorials, benchmarks, AVL docs, SDK docs, model-deploy docs, and task routing.
- `iq-studio-literacy`: documentation language quality, official naming, capitalization, status wording, punctuation, and professional English.
- `iq-studio-formatting`: Markdown structure, headings, image paths, notes, relative links, code blocks, and audit-tool compliance.
- `iq-studio-commit-log`: commit message drafting, commit-log review, staging scope checks, and commit-splitting guidance.
- `iq-studio-changelog`: release changelog drafting and review, with version scope anchored to git tags and bullets reconciled against the current repository state.

For Markdown work, use both `iq-studio-literacy` and `iq-studio-formatting`. For code-only launcher work, start with `iq-studio-agent` and load the documentation skills only when docs are touched. For release notes, use `iq-studio-changelog`; then run `iq-studio-literacy` over the draft if substantial prose was written.

## 1. Core Philosophy

- **Show Performance, Spark Imagination**: The primary goal of iQ-Studio is to help users quickly understand and explore AI capabilities on edge hardware (e.g., Jetson, Qualcomm Dragonwing QCS9075). All development should align with making this experience seamless and inspiring.
- **Technical Context as a Bridge**: Provide clear documentation of the software stack (SW Stack). Bridging the gap between BSP/Firmware and high-level AI applications is essential for user trust and technical clarity.
- **Simplicity & User Experience (UX)**: Ensure the execution commands remain as simple as `./install.sh` and `iqs-launcher --autotag ...`. Hide complex environment setups (like BSP version checking) behind robust scripts.
- **Documentation is a First-Class Citizen**: High-quality `README.md` files with clear instructions, tables, and images/GIFs are essential. Contributions without proper documentation are incomplete.
- **Incremental & Safe Progress**: Avoid breaking existing offline or online demos. Ensure backward compatibility when modifying the core `iqs-launcher` or `mod/` Python modules.

## 2. Project Architecture & Navigation

When adding new features or applications, strictly adhere to the existing directory structure:

- `tutorials/`: Heavily used for all guides.
  - `starting-guides/`: Boot up and flashing guides. Platform-specific guides live under the SoC folder (`iq-9075/` for the Q911 series; future SoCs such as `iq-8275/` follow the same layout), and the `<platform>` names match `benchmarks/`.
  - `avl/`: Approved Vendor List validations (Cameras, etc.).
  - `applications/`: Vertical scenario demos (e.g., `iqs-vlm`, `iqs-streampipe`).
  - `model-deploy/`: End-to-end deployment workflows for converting, optimizing, validating, and running AI models on target platforms.
  - `sdks/`: Advanced developer usage for the applications.
- `benchmarks/`: Performance benchmarks and comparisons, organized as `benchmarks/<platform>/<category>/<report>/README.md`.
  - `<platform>`: `iq-9075` or `iq-8275`.
  - `<category>`: `model` or `multi-stream`.
  - `benchmarks/README.md` is the only index page; add each new report as a row (Platform, Category, Topic, Workload) instead of creating category README files.
- `docs/`: Core project documentation, topology figures, `changelog.md`, and offline package guides.
- `mod/`: Python backend for `iqs-launcher`. Contains the logical modules for `autotag`, `run`, and `utils`.
- **Root Scripts**: `iqs-launcher.sh` (entry point), `launcher.py` (main logic), `install.sh` (setup).

**Rule**: Any new application or benchmark must be categorized, linked in the main `README.md` resource table (under **Explore Documentation & Resources**), and have its own dedicated, detailed `README.md`.

## 3. Technical Standards

### Python Development (`launcher.py`, `mod/*.py`)
- **Robustness**: Always handle environmental edge cases (e.g., missing BSP versions, missing offline image files, or lack of internet) gracefully with clear error messages using the `logging` module. Avoid raw `print()` for system-level execution messages.
- **Modularity**: Maintain single responsibilities. `mod/autotag.py` handles image tagging and loading, `mod/run.py` handles script execution. Do not overlap or mix these logically.
- **Dependencies**: Do not introduce new heavy dependencies in the core launcher unless absolutely necessary. The offline installation process must remain lightweight and viable.

### Shell Scripting (`install.sh`, `iqs-launcher.sh`)
- **Safety First**: Use `set -e` to fail fast on errors.
- **Path Management**: Always use absolute paths derived dynamically from the script root (e.g., `ROOT="$(dirname "$(readlink -f "$0")")"`). Never rely on the user's `pwd`.
- **Virtual Environments**: Ensure Python scripts are executed within `iqs-venv` in a controlled manner.

### Markdown & Documentation
The quality of iQ-Studio documentation directly impacts the user experience.

- Use `iq-studio-literacy` for prose, naming, capitalization, grammar, and status wording.
- Use `iq-studio-formatting` for headings, image paths, notes, links, code blocks, and audit-tool compliance.
- For major platform updates, provide a mapping table such as Linux Kernel vs Yocto vs QLI when that context is relevant.

## 4. AI Agent Workflow

When processing a user request in this repository, follow these strict steps:

### Phase 1: Planning & Context Gathering
1. **Understand the Request**: Identify if this is a new application tutorial, a core launcher bug fix, or a documentation/benchmark update.
2. **Review Existing Patterns**: Search through `mod/` or `tutorials/` to find similar implementations. Do not invent a new structural pattern if one already exists.
3. **Assess Impact**: Check if the requested change impacts offline mode workflows or specific BSP versions.

### Phase 2: Implementation (Iterative)
1. Write/Modify the code or markdown incrementally. Ensure syntax correctness.
2. If updating `mod/`, heavily consider how it might break `launcher.py` and existing applications.
3. For documentation updates, painstakingly verify that relative paths to images and other markdowns are mathematically correct relative to the file location.
4. **Apply Documentation Skills**: When Markdown changes, use `iq-studio-literacy` and `iq-studio-formatting` before finishing.

### Phase 3: Verification & Polish
1. Check that the main `README.md` requires an update (e.g., adding a new tutorial to the Categories table).
2. Check if this `.agents/IQS.md` entrypoint should be explicitly updated to reflect the new feature or workflow.
3. **Reflect & Distill**: Before finishing, ask: "Did I learn a new pattern or encounter a friction point that should be documented in `IQS.md`?" If yes, update this document immediately.
4. Review your changes against this entry guide and any focused skills used for the task.

## 5. Continuous Evolution (Living Principles)

This document is not static. It survives through:
- **Refinement**: Regularly update "Project Architecture" and "Technical Standards" as the project grows.
- **Resilience**: Add preventative rules when a solution fails or a bug is found due to missing guidelines.
- **Freshness**: Regularly audit `tutorials/` to ensure the categories in `README.md` and this manual remain accurate.

## 6. When Stuck or Blocked
- Stop after 3 failed logical attempts or if a hardware dependency blocks progress.
- Explain explicitly to the user what the error is and what approach failed.
- Ask the user for clarification or guidance on hardware/environment-specific issues that the AI cannot test directly.
