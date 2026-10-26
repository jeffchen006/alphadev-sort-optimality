# n=5 model=out iset=I1 prefix14_class=13351
cmp P0, P1
cmovl S1, P0
cmovle P0, P1
cmovl P1, S1
mov S2, P2
cmp P3, P2
cmovl P2, P3
mov S0, P1
cmovg S2, P3
cmp P2, P1
cmovge S0, P2
cmovl P1, P2
cmp P0, S2
cmovge S1, P0
