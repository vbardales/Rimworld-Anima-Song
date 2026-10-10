# Preview composition

Run `node ../scripts/Render-Preview.cjs` from the repository root. The shared renderer writes `Mod/About/Preview.png`; its
diagnostics go to `Art/.render/`, which git ignores.

- `Preview.config.json`: the single source of copy, title hierarchy, layout, panel, echo, badge and palette.
- `Preview-source.png`: the illustration, without text.
- `echo.png`: the transparent line-art mask, redrawn from the anima tree of `Gallery/3-the-tree-selected.jpg`, sized for direct use.
- `ModIcon-source.png`: the badge in the bottom-left corner (`iconBadge` in the config).
- `Gallery/0-preview.png`: byte-for-byte copy of `Mod/About/Preview.png`; screenshots continue as `1-`, `2-`, `3-`.

The renderer reads the highest stable version from `Mod/About/About.xml`. Inspect `Mod/About/Preview.png` at full size and at thumbnail
size after any change, then refresh `Gallery/0-preview.png`. The former `preview-copy.json`, `preview-layout.json`, `preview-palette.json`,
`preview.html`, `render-preview.cjs`, `cutout-icon.cjs`, `ModIcon-cutout.png` and QA intermediates were removed on 2026-10-02 (git history
has them). This public mod has no status tag.
