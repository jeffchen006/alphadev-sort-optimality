# n=5 model=out iset=I1 prefix14_class=8884
mov S2, P3
mov S0, P1
cmp P0, P1
cmovg S0, P0
cmovge P0, P1
cmp S2, P2
cmovge S2, P2
cmovge P2, P3
cmp S0, P2
mov P3, S2
cmovge P1, P2
cmovg P2, S0
cmovg S0, P1
cmp P3, P0
