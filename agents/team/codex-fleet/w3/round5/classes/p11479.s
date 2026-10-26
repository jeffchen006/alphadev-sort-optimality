# n=5 model=out iset=I1 prefix14_class=11479
mov S1, P3
cmp S1, P1
cmovl S1, P1
cmovl P1, P3
cmp P2, P0
cmovg S2, P2
cmovge P2, P0
mov P3, P2
cmovg P0, S2
cmp P3, P1
cmovl P2, P1
cmovl P1, P3
mov P1, S1
cmp P0, S1
