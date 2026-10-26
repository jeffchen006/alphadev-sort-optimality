# n=5 model=out iset=I1 prefix14_class=10842
mov S2, P2
cmp P2, P0
cmovg P2, P0
mov S0, P1
cmovg P0, S2
cmp S0, P3
cmovge S0, P3
cmovl P1, P3
cmp P1, P0
cmovg P3, P0
cmovg P0, P1
cmovg P1, P3
cmp P2, S0
mov P0, P2
