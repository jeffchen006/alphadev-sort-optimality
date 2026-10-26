# n=5 model=out iset=I1 prefix14_class=8421
mov S1, P0
cmp S1, P3
cmovge S1, P3
cmovge P3, P0
cmp P1, P2
mov S0, P1
cmovg S0, P2
cmovg P2, P1
cmp P2, P3
cmovg S2, P3
cmovg P3, P2
cmovg P2, S2
cmp S1, S0
mov P0, S0
