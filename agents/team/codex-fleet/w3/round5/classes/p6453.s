# n=5 model=out iset=I1 prefix14_class=6453
cmp P2, P0
cmovl S1, P2
cmovl P2, P0
mov S0, P3
cmovl P0, S1
cmp S0, P1
cmovg S0, P1
cmovl P3, P1
mov P1, P2
cmp P2, P3
cmovge P2, P3
cmovge P3, P1
cmp S0, P0
cmovl S1, S0
