# n=5 model=out iset=I1 prefix14_class=4389
cmp P1, P3
cmovge S1, P3
cmovge P3, P1
mov S2, P0
cmovg P1, S1
cmp P2, P0
cmovl P0, P2
cmovge S2, P2
cmp S2, P3
mov S0, P3
cmovg S0, S2
cmovg S2, P3
mov P3, P1
cmp P3, P0
