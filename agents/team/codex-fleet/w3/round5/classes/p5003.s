# n=5 model=out iset=I1 prefix14_class=5003
cmp P3, P2
mov S1, P0
mov S2, P2
cmovl P2, P3
cmovle P3, S2
cmovge S2, P3
cmp P1, S1
cmovl P0, P1
cmovg S1, P1
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P3, S1
