# n=5 model=out iset=I1 prefix14_class=3661
cmp P0, P2
cmovge S1, P0
cmovl S1, P2
cmovle P2, P0
mov S0, P2
mov P0, P3
cmp P1, P3
cmovl P3, P1
cmovl P1, P0
cmp P3, P2
cmovg P2, P3
mov S2, P2
mov P0, P1
cmovl S0, P3
