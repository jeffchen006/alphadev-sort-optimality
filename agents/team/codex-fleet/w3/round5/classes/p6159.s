# n=5 model=out iset=I1 prefix14_class=6159
mov S0, P2
cmp P3, P2
cmovg S0, P3
cmovge P3, P2
cmp P1, P0
mov S2, P1
cmovge S2, P0
cmovg P0, P1
cmp S0, P0
cmovge P2, P0
cmovg P0, S0
mov P0, P3
cmovg S0, P2
cmp S2, P0
