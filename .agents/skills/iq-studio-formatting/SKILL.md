---
name: iq-studio-formatting
description: "Use for iQ-Studio Markdown structure and repository documentation formatting: image paths, heading strategy, code block labels, command prompts, notes and warnings, relative links, README section names, and audit-tool verification. Use when editing README files, tutorials, benchmarks, AVL docs, SDK docs, model-deploy docs, docs/ pages, or documentation links."
---

# iQ-Studio Formatting

## Purpose

Use this skill to keep iQ-Studio Markdown predictable, readable, and audit-friendly. Apply it alongside `iq-studio-literacy` when prose quality and naming also matter.

Expected output: Markdown that follows repository structure rules, has valid relative links, and passes the documentation audit tools.

## Visual Resources

- Store PNG, JPG, and GIF files in a `fig/` or `img/` directory beside the corresponding README.
- Use standard Markdown image syntax when possible: `![alt text](./fig/image.png)`.
- Use HTML image tags only when centering or width control is needed: `<div align="center"><img src="./fig/image.png" width="80%"></div>`.
- Do not store images in the repo root or tutorial parent directories.

## Heading Strategy

- Root `README.md` and `tutorials/applications/` must use:
  - `## How to Deploy`
  - `## How to Use`
- `sdks/`, `avl/`, and `benchmarks/` may use contextual headings such as `## Testing Method` when the content requires it.
- Do not skip heading levels. Keep progression logical: `#`, then `##`, then `###`.
- Every core README should include `Core Software Stack & Architecture` when it is part of the core project presentation layer.
- `Explore Documentation & Resources` is the central hub section for the root README resource table.

## Code Blocks

- Add a language label to every fenced code block:
  - Terminal commands: `bash`
  - Python code: `python`
  - JSON configuration: `json`
  - Plain output: `text`
- In `bash` blocks, write commands without a `$` prompt prefix.
- Avoid nested fenced code blocks in examples when a prose explanation is clearer and easier for audit tools to parse.

## Notes And Links

- Start `Note:`, `Notice:`, and `Warning:` messages as Markdown quotes.
  - Correct: `> Note: This config is not default.`
  - Tip style: `> 💡 **Tip:** ...`
- Use relative links for local project files.
- Do not use `file:///`, absolute drive paths, or absolute local paths in documentation links.
- Use the target file basename as link text unless more context is needed.
- After moving files, update all relative links from the file's new location.

## Verification

Run these from the repository root after documentation changes:

```bash
python3 tools/audit_content.py
python3 tools/get_headings.py
```

Use `python3 tools/fix_bash_tags.py` only when an in-place code-fence rewrite is intended.

## Gotchas

- Do not use the auto-fix tool as a substitute for reviewing command labels.
- Do not change presentation-layer headings in root `README.md` or `tutorials/applications/` unless the project standard changes.
- Do not add images without checking their relative paths from the Markdown file that references them.
