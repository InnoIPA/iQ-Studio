---
name: iq-studio-literacy
description: "Use for iQ-Studio documentation language quality: official product names, capitalization, table status wording, typo cleanup, punctuation hygiene, and professional English polish. Use when editing or reviewing iQ-Studio Markdown text, README files, tutorials, benchmarks, AVL docs, SDK docs, model-deploy docs, changelogs, and documentation tables."
---

# iQ-Studio Literacy

## Purpose

Use this skill to keep iQ-Studio documentation linguistically consistent, professional, and brand-safe. Apply it alongside `iq-studio-formatting` when a task changes Markdown structure as well as prose.

Expected output: polished documentation text that preserves technical meaning and uses consistent names, grammar, and status wording.

## Nomenclature

- Use official product names and capitalization:
  - `NVIDIA AGX Orin`
  - `Qualcomm Dragonwing QCS9075`
  - `EXMP-Q911`
  - `Jetson AGX Orin`
  - `Hexagon HTP`
  - `UVC Camera`
  - `MIPI CSI-2`
  - `iQ-Studio`
  - `iqs-launcher`
  - `OGenie`
  - `GenieX`
  - `InnoPPE`
  - `Yocto Linux`
- Avoid informal or incorrect variants such as `qcom`, `AGX ORIN`, `nvidia agx thin`, or inconsistent product casing.

## Grammar Rules

- Use status wording as states, not verbs:
  - Correct: `Supported`, `Not supported`, `Coming soon`
  - Incorrect: `Support`, `Not support`, `Comming soon`
- Keep icon labels consistently capitalized after symbols such as checkmarks or crosses.
- Ensure exactly one space follows periods, semicolons, and colons unless the punctuation ends the line.
- Add a space before an opening parenthesis when it follows a word.
- Remove duplicate punctuation such as `videos..`.
- Prefer direct, object-oriented wording:
  - Better: "You will see it on the screen."
  - Avoid: "You will see in the screen."
- Avoid sentence fragments. When a sentence starts with a condition, include a clear result in the same sentence or the next independent clause.

## Self-Audit

Before finishing documentation work:

1. Search for common typos: `Comming`, `mutil`, and table-cell `Support`.
2. Verify brand and product capitalization for NVIDIA, Qualcomm, Innodisk, iQ-Studio, and related product names.
3. Check punctuation spacing and redundant punctuation.
4. Read changed prose once for natural, professional flow.

## Gotchas

- Do not rewrite technical meaning just to make prose smoother.
- Do not normalize command names, package names, paths, or code identifiers as prose.
- Do not invent new product names or abbreviations.
