# n=5 model=out iset=I1 prefix14_class=13103
mov S0, P0
cmp P1, P0
mov S2, P2
cmovg S0, P1
cmovg P1, P0
cmp P3, P2
cmovl P2, P3
cmovge S2, P3
cmp P2, P1
cmovge P0, P2
cmovg P2, P1
cmovge P1, P0
cmp S0, S2
cmovge S1, S0
