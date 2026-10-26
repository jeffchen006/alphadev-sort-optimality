# n=5 model=out iset=I1 prefix14_class=8131
cmp P1, P2
cmovl S1, P2
cmovl P2, P1
cmovl P1, S1
mov S2, P0
cmp P3, P0
cmovl S2, P3
cmovle P3, P0
mov P0, P2
cmp P2, S2
cmovge P2, S2
cmovl P0, S2
mov S0, P0
cmp P1, P3
