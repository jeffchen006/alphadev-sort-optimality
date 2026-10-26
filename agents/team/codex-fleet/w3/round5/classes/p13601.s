# n=5 model=out iset=I1 prefix14_class=13601
cmp P1, P0
cmovge S0, P1
cmovl S0, P0
cmovl P0, P1
cmp P3, P2
mov S2, P2
cmovle P2, P3
cmovle P3, S2
cmp P2, P0
cmovl S2, P0
cmovl P0, P2
cmovl P2, S2
cmp P3, S0
cmovg S2, S0
