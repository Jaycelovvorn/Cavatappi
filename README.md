# 16-bit Adder/Subtractor (GitHub Pages)

This repository contains:

- `adder_subtractor_16.vhd` — 16-bit adder/subtractor implemented with logic gates (VHDL)
- `tb_adder_subtractor_16.vhd` — VHDL testbench
- `index.html` — static single-file web UI that simulates the 16-bit adder/subtractor in the browser (gate-level, bit-by-bit) and fetches/displays the VHDL sources. This file is intended for GitHub Pages hosting.
- `web_adder.py` and `templates/` — a Flask-based prototype (not required for GitHub Pages). You can keep or remove it.

Hosting on GitHub Pages (quick steps):

1. Create a GitHub repository and push this project to the repository's `main` (or `master`) branch.

   Example (PowerShell):

```powershell
cd "c:\Users\jayce\genius hour"
git init
git add .
git commit -m "Add 16-bit adder/subtractor and static site"
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```

2. Enable GitHub Pages in the repository settings:
   - Go to Settings → Pages
   - Under "Source", choose branch `main` and folder `/ (root)`
   - Save. GitHub will publish the site at `https://<your-username>.github.io/<your-repo>/` within a minute.

3. Open the published URL. The `index.html` is a static app that fetches `adder_subtractor_16.vhd` and `tb_adder_subtractor_16.vhd` from the repository root. If you move the VHDL files, update the fetch paths in `index.html`.

Notes
- The `index.html` performs the adder/subtractor bit-by-bit using boolean expressions (no server). It will work entirely in the browser and is suitable for GitHub Pages.
- If you prefer a custom domain, configure DNS and add a `CNAME` file.

If you'd like, I can:
- Add a small `gh-pages` branch workflow to auto-publish (GitHub Actions).
- Convert the Flask app into a download-only preview or remove the Flask files to keep this repo strictly static.
