# n=5 model=out iset=I1 prefix14_class=8538
cmp P2, P0
cmovl S2, P2
cmovl P2, P0
cmovl P0, S2
cmp P3, P1
mov S1, P1
cmovl S1, P3
cmovg P1, P3
cmp P2, P1
mov P3, P1
cmovge P3, P2
mov P3, S1
cmovl P1, P2
cmp P3, P0
