# n=5 model=out iset=I1 prefix14_class=7787
mov S1, P3
cmp P1, S1
cmovge S1, P1
cmovge P1, P3
cmp P2, P0
cmovl S0, P2
cmovl P2, P0
cmovge S0, P0
cmp P1, S0
cmovg P0, S0
cmovg S0, P1
cmovg P1, P0
mov P1, P2
cmp P1, S1
