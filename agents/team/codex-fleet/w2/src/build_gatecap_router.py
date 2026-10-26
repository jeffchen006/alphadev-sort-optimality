#!/usr/bin/env python3
"""Add an explicit optional conditional-move bound to the conservative router.

MAXGATES limits conditional moves, including recomputation. With no setting,
the generated router uses exactly the same gate budget as dagx_safe.cpp.
"""
from pathlib import Path

s=Path('src/dagx_safe.cpp').read_text()
s=s.replace('static int C, K, BUDGET;', 'static int C, K, BUDGET, MAXGATES;')
s=s.replace('if (ngates() + lbo > BUDGET)',
            'if (ngates() + lbo > min(BUDGET, MAXGATES))')
s=s.replace('  if (newok) {\n    int g = nodes.size();',
            '  newok = newok && ngates() + max(1, lbo) <= MAXGATES;\n'
            '  if (newok) {\n    int g = nodes.size();')
s=s.replace('C = sk.size(); BUDGET = K - C;',
            'C = sk.size(); BUDGET = K - C; MAXGATES = BUDGET;\n'
            '  if (getenv("MAXGATES")) MAXGATES = min(MAXGATES, atoi(getenv("MAXGATES")));\n'
            '  printf("ROUTING_SCOPE gate_cap=%d\\n", MAXGATES);')
s=s.replace('ROUTER conservative_open_bound v1',
            'ROUTER conservative_open_bound gatecap_v1')
assert 'ROUTING_SCOPE' in s
assert 'min(BUDGET, MAXGATES)' in s
Path('src/dagx_gatecap.cpp').write_text(s)
