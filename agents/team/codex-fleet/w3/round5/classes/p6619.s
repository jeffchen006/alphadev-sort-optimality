# n=5 model=out iset=I1 prefix14_class=6619
cmp P1, P2
cmovge S1, P2
cmovl S1, P1
cmovg P2, P1
cmp P3, P0
mov P1, P3
cmovl P3, P0
cmovg P1, P0
mov P0, P3
cmp P2, P0
cmovge P3, P2
cmovg P2, P0
cmp P1, S1
cmovge S2, P1
