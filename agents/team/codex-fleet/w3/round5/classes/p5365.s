# n=5 model=out iset=I1 prefix14_class=5365
cmp P2, P3
mov S0, P2
cmovge P2, P3
cmovl S0, P3
mov S1, P0
cmp P1, P0
cmovl S1, P1
cmovg P0, P1
cmp S1, P2
mov P1, P2
cmovge P2, S1
cmovl P1, S1
cmp S0, P0
cmovg S1, S0
