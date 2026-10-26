# n=5 model=out iset=I1 prefix14_class=2690
mov S2, P0
cmp P3, P1
mov S1, P1
cmovl S1, P3
cmovg P1, P3
cmp P0, P2
cmovg P0, P2
cmovl S2, P2
cmp P1, S2
mov P3, P1
cmovge P3, S2
cmovl P1, S2
cmp S1, P0
cmovg P2, S1
