# n=5 model=out iset=I1 prefix14_class=6271
cmp P3, P2
cmovl S1, P3
cmovl P3, P2
cmovge S1, P2
mov S2, P3
mov P2, P0
cmp P1, P2
cmovge P0, P1
cmovle P2, P1
cmp P0, P3
cmovl S2, P0
cmovl P0, P3
mov P3, P2
mov P0, S2
