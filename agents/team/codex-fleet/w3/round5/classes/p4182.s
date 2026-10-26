# n=5 model=out iset=I1 prefix14_class=4182
mov S1, P3
cmp P2, S1
cmovl P3, P2
cmovge S1, P2
cmp P1, P0
mov S2, P3
mov P2, P1
cmovl P1, P0
cmovl P0, P2
cmp P0, P3
cmovl S2, P0
cmovg P3, P0
cmp P1, S1
cmovg P0, P1
