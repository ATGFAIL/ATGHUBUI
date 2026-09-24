#!/usr/bin/env python3
"""Expand a short rename list into a full map file.

Input lines: `LINE:COL NEW` (comments with #). The OLD name is looked up
from `atg-rename dump` output so positions and names cannot drift apart.
Usage: mkmap.py DUMP.tsv SHORT.txt > MAP.map
"""
import sys

def main():
    dump_path, short_path = sys.argv[1], sys.argv[2]
    names = {}
    for line in open(dump_path, encoding="utf-8"):
        if line.startswith("\t"):
            continue
        parts = line.rstrip("\n").split("\t")
        if len(parts) >= 2:
            names[parts[0]] = parts[1]
    out = []
    for raw in open(short_path, encoding="utf-8"):
        text = raw.split("#", 1)[0].strip()
        comment = raw.split("#", 1)[1].strip() if "#" in raw else ""
        if not text:
            if comment:
                out.append("# " + comment)
            continue
        position, new = text.split()
        if position not in names:
            sys.exit(f"no binding at {position}")
        out.append(f"{position} {names[position]} {new}")
    print("\n".join(out))

main()
