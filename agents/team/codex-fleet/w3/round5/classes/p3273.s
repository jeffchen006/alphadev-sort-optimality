# n=5 model=out iset=I1 prefix14_class=3273
mov S2, P1
mov S0, P0
cmp S2, P3
cmovge P1, P3
cmovg P3, S2
cmp P2, S0
cmovg S0, P2
cmovge P2, P0
mov P0, S0
mov S1, P2
cmp P2, P1
cmovg P2, P1
cmovge P1, S1
mov P2, P1
