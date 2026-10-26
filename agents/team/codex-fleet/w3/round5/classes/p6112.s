# n=5 model=out iset=I1 prefix14_class=6112
mov S1, P3
cmp S1, P2
cmovl S1, P2
cmovl P2, P3
cmp P0, P1
mov P3, P0
cmovge P0, P1
cmovl P3, P1
cmovg P1, P3
cmp P3, S1
cmovge P1, S1
cmovge S1, P3
cmp P2, P0
cmovg S1, P2
