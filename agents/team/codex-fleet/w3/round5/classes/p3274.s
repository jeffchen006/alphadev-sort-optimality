# n=5 model=out iset=I1 prefix14_class=3274
mov S2, P1
cmp S2, P3
mov S0, P2
cmovge P1, P3
cmovg P3, S2
cmp P0, P2
cmovge P2, P0
cmovg P0, S0
mov S2, P0
mov S0, P2
cmp P0, P1
cmovge P0, P1
cmovg P1, S2
mov P0, P1
