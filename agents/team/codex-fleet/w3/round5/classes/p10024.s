# n=5 model=out iset=I1 prefix14_class=10024
cmp P2, P1
mov S0, P0
cmovge S1, P1
cmovg P1, P2
mov S2, P1
cmovg P2, S1
cmp P3, P0
cmovg S0, P3
cmovl P0, P3
cmp S2, S0
cmovg S2, S0
mov P3, P2
cmovl P1, S0
cmp P0, P3
