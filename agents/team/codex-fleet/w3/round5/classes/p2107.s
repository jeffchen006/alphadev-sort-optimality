# n=5 model=out iset=I1 prefix14_class=2107
cmp P0, P3
mov S0, P3
cmovg S0, P0
cmovl P3, P0
cmp P2, P1
mov S2, P1
cmovg S2, P2
cmovg P2, P1
cmp S0, S2
cmovge S1, S2
cmovge S2, S0
mov S2, P2
cmovge S0, S1
cmp S2, P3
