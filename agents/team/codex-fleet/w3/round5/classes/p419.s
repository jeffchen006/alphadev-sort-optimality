# n=5 model=out iset=I1 prefix14_class=419
mov S1, P3
cmp P0, P3
cmovg S1, P0
cmovl P3, P0
mov S0, P2
cmp S0, P1
cmovg S0, P1
cmovge P1, P2
cmp P3, S0
mov P2, S0
cmovl P2, P3
cmovl P3, S0
cmp S1, P1
cmovge S2, P1
