# n=5 model=out iset=I1 prefix14_class=11314
mov S2, P2
cmp S2, P3
cmovge S2, P3
cmovle P2, P3
cmp P1, P0
cmovge P3, P1
cmovge P1, P0
cmovg P0, P3
cmp P0, P2
cmovge S0, P0
cmovg P0, P2
mov S1, P1
cmovg P2, S0
cmp P1, S2
