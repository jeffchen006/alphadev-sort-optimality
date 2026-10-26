# n=5 model=out iset=I1 prefix14_class=11116
mov S2, P3
mov S0, P1
cmp P2, S2
cmovl S2, P2
cmovge P3, P2
cmp P1, P0
cmovle P1, P0
cmovl P0, S0
cmp P1, P3
cmovl S0, P3
cmovl P3, P1
cmovl P1, S0
cmp P0, S2
mov P2, P3
