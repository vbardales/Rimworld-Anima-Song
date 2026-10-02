# Preview composition

Run `node ../scripts/Render-Preview.cjs` from the repository root. The shared renderer captures
at 896 × 504 after the image and fonts load, verifies platform fonts, and writes the final PNG
plus its HTML and QA artifacts.

- `Preview.png`: retained illustration without text, copied unchanged from `Preview-source.png`.
- `preview-copy.json`: exact wording, title hierarchy, panel, line-art and ModIcon placement.
- `echo.png`: final transparent line-art mask, redrawn from the selected anima tree in
  `Gallery/3-the-tree-selected.jpg` and already sized for direct use; no renderer cleanup or fade.
- `ModIcon-cutout.png` (`cutout-icon.cjs`): `ModIcon-source.png` with its near-black background flood-filled
  transparent from the border inward. One-off, re-run only if the source icon changes; the output is committed.
- `preview-palette.json`: the only source of overlay colours.
- `Preview-layout.html`, `Preview-qa.json` and `Preview-background-qa.png`: shared-renderer QA artifacts.
- `Gallery/0-preview.png`: byte-for-byte copy of `Mod/About/Preview.png`; screenshots continue as `1-`, `2-`, `3-`.

The renderer reads the highest stable version from `Mod/About/About.xml` and writes
`Mod/About/Preview.png`. Inspect that file at full size and thumbnail size after any change, then
refresh `Gallery/0-preview.png`. The older local HTML, JSON layout and renderer remain historical
evidence only. The secondary colour is retained for completeness; this public mod has no status tag.
