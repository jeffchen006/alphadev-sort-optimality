#!/usr/bin/env python3
"""Print (#cmp, #cmov, #mov) of program files (out lines are free)."""
import sys
for f in sys.argv[1:]:
    c = m = v = 0
    for line in open(f):
        op = line.split("#", 1)[0].split()
        if not op:
            continue
        op = op[0]
        c += op == "cmp"
        m += op.startswith("cmov")
        v += op == "mov"
    print(f"{f}: k={c + m + v} cmp={c} cmov={m} mov={v}")
