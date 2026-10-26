# n=5 model=out iset=I1 prefix14_class=6368
cmp P1, P3
cmovge S1, P1
cmovg P1, P3
cmovg P3, S1
mov S0, P2
mov S2, P3
cmp P0, S0
cmovg P2, P0
cmovle S0, P0
cmp P2, P3
cmovle S2, P2
cmovg P3, P2
mov P0, P1
cmp S0, P0
