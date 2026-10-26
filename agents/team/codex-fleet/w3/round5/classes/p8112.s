# n=5 model=out iset=I1 prefix14_class=8112
mov S2, P2
cmp P3, S2
cmovl S2, P3
cmovl P3, P2
cmp P0, P1
mov S0, S2
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
cmp S2, P1
cmovg S2, P1
cmovl S0, P1
cmp P3, P0
mov P1, P3
