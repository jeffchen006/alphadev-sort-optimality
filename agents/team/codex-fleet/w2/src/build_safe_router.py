#!/usr/bin/env python3
"""Use a conservative lower bound when a new gate can serve an open need.

The old new-gate test adds one gate to the lower bound for all other open
needs. The new gate can serve one of those needs. In the boundary case,
recompute the lower bound with the current need included instead.
"""
from pathlib import Path
for source,target in [('dagx.cpp','dagx_safe.cpp'),('dagx_flags.cpp','dagx_flags_safe.cpp')]:
    p=Path('src')/source
    s=p.read_text()
    old='''  if (ngates() + 1 + lbo + cpl <= BUDGET) {
    int g = nodes.size();'''
    new='''  bool newok = ngates() + 1 + lbo + cpl <= BUDGET;
  if (!newok && ngates() + max(1, lbo) + cpl <= BUDGET) {
    st.push_back(it);
    int allOpen = lbOpen(st);
    st.pop_back();
    newok = ngates() + max(1, allOpen) + cpl <= BUDGET;
  }
  if (newok) {
    int g = nodes.size();'''
    assert old in s
    s=s.replace(old,new)
    s=s.replace('  K = atoi(argv[2]);',
                '  printf("ROUTER conservative_open_bound v1\\n");\n  K = atoi(argv[2]);')
    (Path('src')/target).write_text(s)
