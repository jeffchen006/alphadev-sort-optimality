# n=5 model=out iset=I1 prefix14_class=7882
mov S2, P2
cmp S2, P0
cmovg S2, P0
cmovg P0, P2
mov P2, P1
cmp P2, P3
cmovl P1, P3
cmovg P2, P3
cmp S2, P2
cmovge S0, S2
cmovge S2, P2
mov P3, P1
cmovg P2, S0
cmp P1, P0
