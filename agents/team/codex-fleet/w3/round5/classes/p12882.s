# n=5 model=out iset=I1 prefix14_class=12882
cmp P3, P0
cmovl S2, P0
cmovl P0, P3
cmovl P3, S2
cmp P1, P2
cmovle S0, P1
cmovg S0, P2
cmovl P1, P2
mov P2, S0
cmp P2, P0
cmovl P2, P0
cmovg S0, P0
cmp P1, P3
mov P0, P1
