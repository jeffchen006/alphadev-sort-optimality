# n=5 model=out iset=I1 prefix14_class=171
mov S1, P2
cmp P2, P3
cmovg S1, P3
cmovl P2, P3
mov S0, P0
cmp P1, S0
cmovl P0, P1
cmovl P1, S0
cmovl S0, P0
cmp S1, P0
cmovg S0, S1
cmovg S1, P0
cmp P2, P1
mov P3, S0
