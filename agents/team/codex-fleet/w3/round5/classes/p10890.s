# n=5 model=out iset=I1 prefix14_class=10890
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmovle S2, P3
cmp P0, P2
cmovg P3, P2
cmovge P2, P0
cmovg P0, P3
mov S1, P2
cmp S1, P1
cmovle P2, P1
cmovle P1, S1
cmp S2, P0
cmovle S1, P0
