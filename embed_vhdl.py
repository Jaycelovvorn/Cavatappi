"""
embed_vhdl.py

Simple utility to produce an HTML file with VHDL sources embedded into the page.
This avoids fetch-based loading and therefore avoids CORS when viewing the page on any origin.

Usage:
  python embed_vhdl.py index.html adder_subtractor_16.vhd tb_adder_subtractor_16.vhd > index_embedded.html

Or run without args (will try to read files from repo root and write index_embedded.html).
"""
import sys
from pathlib import Path


def embed(index_path, vhd_files, out_path):
    idx = Path(index_path).read_text()
    for fname in vhd_files:
        p = Path(fname)
        content = f"{fname} not found"
        if p.exists():
            content = p.read_text()

        marker = f"<!-- EMBED:{fname} -->"
        if marker in idx:
            idx = idx.replace(marker, '<pre>' + content + '</pre>')
        else:

            base = Path(fname).stem
            pre_id = 'vhdl1' if 'adder' in fname else 'vhdl2'
            idx = idx.replace(f"<pre id=\"{pre_id}\">Loading…</pre>", '<pre>' + content + '</pre>')

    Path(out_path).write_text(idx)
    print(f"Wrote {out_path}")


if __name__ == '__main__':
    if len(sys.argv) >= 4:
        _, index_path, *vhd_files = sys.argv
        out = 'index_embedded.html'
        embed(index_path, vhd_files, out)
    else:

        embed('index.html', ['adder_subtractor_16.vhd', 'tb_adder_subtractor_16.vhd'], 'index_embedded.html')

