# n=5 model=out iset=I1 prefix14_class=1603
mov S0, P0
mov S1, P2
cmp P2, P3
cmovl P2, P3
cmovg S1, P3
cmp P1, S0
cmovle P0, P1
cmovg S0, P1
mov P3, S1
cmp S1, P0
mov S2, S0
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
