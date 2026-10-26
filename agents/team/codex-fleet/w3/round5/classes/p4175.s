# n=5 model=out iset=I1 prefix14_class=4175
mov S1, P1
cmp P0, P1
cmovge P1, P0
cmovl S1, P0
cmp P2, P3
cmovl S2, P2
cmovl P2, P3
cmovl P3, S2
mov P0, S1
cmp P3, P0
cmovl S1, P3
cmovg P0, P3
mov P3, P2
mov S1, P0
