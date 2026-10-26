#!/usr/bin/env python3
"""Depth of team .s files with the latency agent's own code (agents/latency/prog.py). Usage: depthchk.py f.s ..."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../../latency'))
import prog
for f in sys.argv[1:]:
    r = prog.parse_team(f); n, p = r[0], r[1]
    print('%s: U=%d E=%d' % (f, prog.depth(p, prog.LAT['U'])[0], prog.depth(p, prog.LAT['E'])[0]))
