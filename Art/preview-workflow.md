# Preview composition

Run `node Art/render-preview.cjs` from the repository root with `playwright` and `sharp`
available to Node.js and Google Chrome installed. The script starts a temporary loopback
server, captures at 896 × 504 after the image and fonts load, verifies platform fonts and
contrast, saves the final PNG and QA artifacts, then closes the browser and server.

- `Preview.png`: retained illustration without text, copied unchanged from `Preview-source.png`.
- `preview.html`: HTML/CSS composition; load via a local HTTP server for interactive inspection.
- `preview-layout.json`: exact existing wording, version and composition parameters.
- `preview-palette.json`: the only source of overlay colours.
- `preview-qa.json`: fonts, coordinates, byte count and measured contrast results.
- `preview-background.png`: rendered composite with text and its shadows hidden.
- `preview-268.png`: small-size visual QA.

The renderer checks the version against `Mod/About/About.xml` and fails if parameters are stale.
It writes `Mod/About/Preview.png`. Inspect that file and the small preview after any change.
The secondary colour is saved for completeness; this original public mod has no status tag.
