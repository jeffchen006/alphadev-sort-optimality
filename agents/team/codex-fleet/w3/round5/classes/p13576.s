# n=5 model=out iset=I1 prefix14_class=13576
cmp P0, P2
cmovl S1, P2
cmovl P2, P0
cmovge S1, P0
cmp P3, P1
mov P0, P2
cmovge S0, P3
cmovge P3, P1
cmovge P1, S0
cmp P2, P3
cmovge P2, P3
cmovle P0, P3
cmp P1, S1
mov P2, P0
