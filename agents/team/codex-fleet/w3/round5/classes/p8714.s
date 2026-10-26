# n=5 model=out iset=I1 prefix14_class=8714
mov S2, P2
cmp P1, P0
cmovge S0, P0
cmovg P0, P1
cmovg P1, S0
cmp S2, P3
cmovl P2, P3
cmovg S2, P3
mov S1, P0
cmp P2, S1
cmovl P0, P2
cmovge S1, P2
mov P2, P1
mov P3, P0
