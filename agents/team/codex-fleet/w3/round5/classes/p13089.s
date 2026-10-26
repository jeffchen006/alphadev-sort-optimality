# n=5 model=out iset=I1 prefix14_class=13089
cmp P3, P1
cmovge S1, P1
cmovl S1, P3
cmovl P3, P1
cmp P0, P2
cmovle P1, P0
cmovl P0, P2
cmovge P1, P2
mov P2, P1
cmp P2, S1
cmovl P2, S1
cmovl S1, P1
cmp P0, P3
cmovl S0, P0
