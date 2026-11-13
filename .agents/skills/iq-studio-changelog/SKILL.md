---
name: iq-studio-changelog
description: "Use for iQ-Studio release changelog drafting and review. Apply when the user asks for a changelog entry, a vX.Y.Z summary, a release-notes draft, or guidance on what should appear in `docs/changelog.md`. Anchors version scope to the git tag and reconciles every bullet against the current repository state."
---

# iQ-Studio Changelog

## Purpose

Use this skill to draft entries for `docs/changelog.md` that match the iQ-Studio release-notes style and accurately describe what a reader will see in the new version. The output is user-facing, not developer-facing — it summarizes the released surface, not the commit log.

Expected output: a markdown block ready to paste under a new `## vX.Y.Z` heading in `docs/changelog.md`. Do not edit `docs/changelog.md` directly unless the user explicitly asks for it.

## Scope Summary

Use this skill when the user asks for a changelog, release notes, version summary, or "what's new since vX.Y.Z". It complements `iq-studio-commit-log`: the commit-log skill drafts per-commit messages from a diff, this skill aggregates many commits into one user-visible release summary.

Do not use this skill for commit message drafting (use `iq-studio-commit-log`) or for prose polish inside the changelog (apply `iq-studio-literacy` after the draft is ready).

## Highest Principles

- The git **tag** is the version boundary, not the commit that updated `changelog.md`. Resolve `vX.Y.Z` with `git rev-list -n 1 vX.Y.Z` before listing any commits.
- Every bullet must describe state that is visible in the **current repository** at HEAD. Verify the file or section still exists and still says what the bullet claims before keeping the line.
- Intermediate work that was overwritten, moved, or deleted later in the same release window is invisible to the reader — drop it, even if its commit is in range.
- Group commits by user-visible theme, not by commit count. Multiple commits that ship one capability collapse into one bullet.
- Match the existing `docs/changelog.md` voice: short past-tense bullets, no trailing periods, no commit hashes, no PR numbers.
- Do not name third-party vendors or competing platforms (for example NVIDIA or Jetson) in changelog bullets. When a benchmark compares against another vendor's platform, say that a comparison with another platform was added, and leave the product names to the benchmark page.
- A bullet's section is decided by comparing the **previous tagged release** against **HEAD**, taking only the final state. A reader who upgrades from v(N-1) to v(N) experiences the delta in HEAD, not the path the commits took to get there.

## Workflow

1. Find the previous release boundary:
   - `git tag -l --sort=-creatordate | head -5` — confirm the previous tag name.
   - `git rev-list -n 1 vX.Y.Z` — resolve it to a commit.
2. List the in-range work:
   - `git log vX.Y.Z..HEAD --no-merges --pretty=format:"%h %s"`
   - `git diff vX.Y.Z..HEAD --diff-filter=A --name-only` for additions.
   - `git diff vX.Y.Z..HEAD --diff-filter=D --name-only` for removals.
3. Reconcile against the previous-tag → HEAD delta, **using HEAD's final state as the source of truth**. For every candidate bullet, run this comparison before classifying it:
   - `git show <previous-tag>:<path>` (or grep that output) — what did v(N-1) readers see?
   - Read the same path/section at HEAD — what do v(N) readers see now?
   - The classification follows from that delta:
     - **Did not exist at v(N-1), exists now → `Feat`** (new tutorial, new benchmark, new pointer to an external resource, new section that exposes something previously unreachable, new script a reader/contributor can run).
     - **Existed at v(N-1) and still exists, but the structure/location changed → `Refactor`** (split into multiple pages, content moved to a sibling repo, page consolidated).
     - **Existed at v(N-1) in a broken state, now corrected → `Fixes`**. If the broken state never shipped to readers (e.g., a `fix:` commit only repairs content added earlier in the same release window), it is not a Fix — fold it into the bullet that introduces that content.
     - **Position-only or meta housekeeping the reader does not encounter → `Chore`**.
   - If two commits in range contradict (add then remove, add then rewrite), follow HEAD; the intermediate state is invisible to readers and must not appear as a bullet.
4. Group commits by user-visible theme. Typical groupings:
   - Multiple commits on the same tutorial → one bullet.
   - Polish/wording commits on top of a larger feature → fold into that feature's bullet.
   - Asset compression + the helper tool that does it → one bullet covers both.
5. Drop noise that the reader cannot perceive:
   - Pure wording or formatting refinements already implied by a higher-level bullet.
   - Changes already announced in the previous release (do not re-announce extensions of a v0.0.(N-1) feature unless they cross a new threshold).
   - Internal-only renames or moves that do not change any user-facing path or behavior.
6. Sort each bullet into the section table below.
7. Draft the entry and present it to the user. Do not write to `docs/changelog.md` unless asked.

## Section Format

Follow the structure already used in `docs/changelog.md`:

```markdown
## vX.Y.Z
### Feat

- Bullet describing a new or changed user-visible capability

### Refactor

- Bullet describing a structural change visible to users (path moves, repo splits, content relocation)

### Fixes

- Bullet describing a bug fix or corrected link

### Chore

- Bullet describing tooling, repo organization, or asset maintenance the user may notice
```

Rules:

- Use the four sections in this order. Omit a section entirely if it has no bullets — do not leave an empty heading.
- One bullet = one user-visible idea. Multi-clause bullets are fine when several details belong to the same idea ("Added X covering A and B").
- No trailing periods on bullets, matching prior versions.
- Do not include commit hashes, PR numbers, author names, or issue IDs.
- Reference paths with backticks when they help a reader find the file (e.g., `` `tools/compress_gifs.sh` ``, `` `docs/how-to-use-iqs-launcher.md` ``). Do not over-decorate prose with paths the reader will not look up.

## Section Selection

| Section | Use for |
| :--- | :--- |
| `Feat` | An artifact, capability, guide, benchmark, or resource pointer that is present at HEAD but absent at the previous tag. Confirm by diffing v(N-1) → HEAD and reading HEAD; if a v(N-1) reader could not reach it and a HEAD reader can, it belongs here — regardless of which commit subjects in range said "add", "fix", or "refactor". Includes new tutorials, new benchmarks, new sibling-repo pointers, and new scripts a reader or contributor can run. |
| `Refactor` | Structural changes visible to readers but not new capability — e.g., content moved to a sibling repository, a guide split into multiple pages, a tutorial deprecated in favor of an external source. |
| `Fixes` | A defect that shipped to readers of the previous tagged release and is corrected at HEAD. In-range `fix:` commits that only repair content introduced within the same release window are invisible to readers and do not warrant a Fix bullet — fold them into the bullet that introduces that content. |
| `Chore` | Position-only or housekeeping changes the iQ-Studio reader does not encounter while following tutorials, running tools, or browsing benchmarks — file relocations, reshuffling of agent guidance under `.agents/`, license/copyright updates, configuration tweaks. Use Chore when the change is a move or meta-content adjustment; a new artifact the reader can actively run, follow, or reach is `Feat`, regardless of which directory it lives in. |

When a commit could plausibly land in two sections, follow the reader's experience: if they will execute new steps, it is `Feat`; if they will only notice the page is reorganized, it is `Refactor`.

## Style

Mirror the phrasing patterns already used in `docs/changelog.md`:

```text
Added a Qualcomm OTA Guide under Starting Guides, covering both Capsule and OSTree update flows
Split the Q911 Quick Start Guide into shared boot-up steps plus per-OS interaction pages for Yocto Linux and Ubuntu
Simplified the GMSL and MIPI camera AVL pages so the full driver content lives in `iQ-Cam__manifest`
Corrected the `iQ-ubuntu__manifest` URL and other broken cross-document links
Added `tools/compress_gifs.sh` and re-encoded oversized GIFs to shrink repository size
```

Guidelines:

- Lead with a past-tense verb: `Added`, `Updated`, `Reworked`, `Split`, `Simplified`, `Removed`, `Corrected`, `Fixed`, `Expanded`.
- Name the user-visible artifact (tutorial title, README section, file path). Avoid internal module names that only contributors know.
- Prefer one strong sentence over a sentence-plus-clause that repeats information.

## Gotchas

- The changelog commit (the one that updates `docs/changelog.md` for the previous version) is **not** the version boundary. Always resolve via `git tag`.
- A commit's subject often describes intent, not outcome. If a later commit reverted or replaced that work, the earlier subject is misleading — trust the file tree at HEAD.
- Camera tutorial content, model-deploy pipeline sources, and similar pages have been migrated to sibling repositories (`iQ-Cam__manifest`, `iQ-Foundry`, etc.) in past releases. Before claiming a detail change in those areas, confirm the detail is still hosted in iQ-Studio.
- Do not invent version numbers. If the user has not stated the next version, ask before drafting the heading.
- Do not write to `docs/changelog.md` proactively. Present the draft and wait for confirmation.
- Commit prefixes (`feat:`, `fix:`, `refactor:`, `chore:`) describe authorial intent within the release window. They are **not** the section selector. Always re-derive the section from the v(N-1) → HEAD delta.
