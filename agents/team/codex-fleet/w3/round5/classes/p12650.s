# n=5 model=out iset=I1 prefix14_class=12650
mov S2, P0
cmp P3, P0
cmovge S2, P3
cmovl P0, P3
cmp P2, P1
cmovl S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P0, P1
cmovle P3, P1
cmovle P1, P0
cmovl P0, P3
mov P1, P2
cmp P1, S2
