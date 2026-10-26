# n=5 model=out iset=I1 prefix14_class=1968
mov S2, P0
cmp P2, P1
cmovge S0, P1
cmovl S0, P2
cmovl P2, P1
cmp P3, S2
cmovle P0, P3
cmovg S2, P3
mov P3, P2
cmp P2, S2
cmovl P3, S2
cmovl S2, P2
cmp P0, S0
cmovl P3, P0
