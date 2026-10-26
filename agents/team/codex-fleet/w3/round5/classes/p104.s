# n=5 model=out iset=I1 prefix14_class=104
cmp P2, P0
cmovl S1, P0
cmovge S1, P2
mov S0, P1
cmovge P2, P0
cmp P3, P1
cmovge S0, P3
cmovl P1, P3
cmp P1, P2
cmovl S2, P2
cmovle P2, P1
cmovl P1, S2
mov P2, S1
mov P0, P1
