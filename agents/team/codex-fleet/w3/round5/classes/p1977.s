# n=5 model=out iset=I1 prefix14_class=1977
cmp P2, P1
mov S0, P2
cmovg S0, P1
cmovle P2, P1
cmp P3, P0
cmovl S2, P0
cmovl P0, P3
cmovge S2, P3
mov P3, P2
cmp P3, S2
cmovl P2, S2
mov P2, S0
cmovl S2, P3
mov P1, S2
