#!/usr/bin/env python3
"""Strengthen the open-requirement lower bound with a maximum clique.

A conflict edge means that one value column cannot satisfy both needs.
Every clique therefore needs at least one distinct new value per vertex.
The search finds actual cliques only, so even its call cap is conservative.
"""
from pathlib import Path
for source,target in [('dagx_safe.cpp','dagx_clique.cpp'),
                      ('dagx_flags_safe.cpp','dagx_flags_clique.cpp')]:
    s=(Path('src')/source).read_text()
    old='''  return pk.size();
}'''
    new='''  int best = pk.size();
  int n = open.size();
  if (n > best && n <= 63) {
    u64 adj[64] = {};
    for (int i=0;i<n;i++) for (int j=0;j<i;j++)
      if (conflict(*open[i],*open[j])) {
        adj[i] |= 1ULL<<j; adj[j] |= 1ULL<<i;
      }
    int steps=0;
    function<void(u64,int)> clique = [&](u64 cand,int size) {
      if (size>best) best=size;
      if (++steps>1000 || size+__builtin_popcountll(cand)<=best) return;
      while (cand) {
        int v=__builtin_ctzll(cand); cand &= cand-1;
        clique(cand & adj[v],size+1);
        if (size+__builtin_popcountll(cand)<=best) return;
      }
    };
    clique((1ULL<<n)-1,0);
  }
  return best;
}'''
    assert old in s
    s=s.replace(old,new)
    s=s.replace('ROUTER conservative_open_bound v1',
                'ROUTER conservative_open_bound clique v1')
    (Path('src')/target).write_text(s)
