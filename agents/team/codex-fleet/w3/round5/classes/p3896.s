# n=5 model=out iset=I1 prefix14_class=3896
mov S0, P2
cmp S0, P3
cmovge P2, P3
cmovg P3, S0
mov S1, P2
cmp P1, P0
cmovl S0, P1
cmovl P1, P0
cmovl P0, S0
cmp S1, P0
cmovl P2, P0
cmovl P0, S1
mov P0, P2
cmp P3, P1
