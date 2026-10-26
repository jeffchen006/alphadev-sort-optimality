# n=5 model=out iset=I1 prefix14_class=8820
cmp P0, P1
mov S2, P0
cmovge S2, P1
mov S0, P2
cmovge P1, P0
cmp S0, P3
cmovge S0, P3
cmovge P3, P2
cmp P3, P1
cmovg P2, P1
cmovge P1, P3
cmovg P3, P2
cmp S2, S0
mov P1, P3
