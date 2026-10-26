# n=5 model=out iset=I1 prefix14_class=2373
cmp P1, P2
mov S1, P2
mov S0, P0
cmovle S1, P1
cmovge P2, P1
cmp P3, S0
cmovle S0, P3
cmovge P0, P3
mov S2, P2
cmp S2, P0
cmovle P2, P0
cmovle P0, S2
cmp S1, S0
cmovg P2, S0
