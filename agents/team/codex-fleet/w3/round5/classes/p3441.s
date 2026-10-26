# n=5 model=out iset=I1 prefix14_class=3441
cmp P3, P2
cmovge S2, P2
cmovge P2, P3
cmovg P3, S2
mov S0, P0
cmp P0, P1
cmovg S0, P1
cmovle P0, P1
mov P1, P3
cmp S0, P3
cmovg P1, S0
cmovge S0, P3
mov P3, P2
cmp P0, P2
