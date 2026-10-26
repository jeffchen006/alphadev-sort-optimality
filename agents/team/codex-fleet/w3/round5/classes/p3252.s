# n=5 model=out iset=I1 prefix14_class=3252
mov S0, P0
cmp P1, S0
cmovle S0, P1
mov S2, P3
cmovg P0, P1
mov P1, S0
cmp P2, P3
cmovge S2, P2
cmovg P2, P3
cmp P1, P2
cmovle S0, P2
cmovg P1, P2
cmp S2, P0
cmovle P1, S2
