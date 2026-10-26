# n=5 model=out iset=I1 prefix14_class=4270
cmp P2, P3
mov S0, P2
cmovg S0, P3
cmovl P2, P3
cmp P0, P1
cmovge S2, P0
cmovg P0, P1
cmovg P1, S2
mov P3, P0
cmp P0, S0
cmovle P3, S0
cmovl S0, P0
cmovle P0, P3
cmp P1, P2
