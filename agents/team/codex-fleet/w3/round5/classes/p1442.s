# n=5 model=out iset=I1 prefix14_class=1442
mov S2, P0
cmp S2, P1
mov S0, P3
cmovg S2, P1
cmovg P1, P0
cmp P2, S0
cmovg S0, P2
mov P0, P1
cmovg P2, P3
cmp S0, P1
cmovg P0, S0
cmovge S0, P1
cmp P2, S2
cmovg P3, S2
