# n=5 model=out iset=I1 prefix14_class=4091
mov S2, P2
mov S1, P0
cmp P3, S2
cmovge S2, P3
cmovle P2, P3
cmp P1, S1
cmovge P0, P1
cmovge P1, S1
mov S0, P1
cmp P2, S0
cmovg P1, P2
cmovg P2, S0
cmp S2, P0
cmovge S1, S2
