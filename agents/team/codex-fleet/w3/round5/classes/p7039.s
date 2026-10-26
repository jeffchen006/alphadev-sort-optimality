# n=5 model=out iset=I1 prefix14_class=7039
cmp P2, P0
mov S2, P0
cmovge P0, P2
mov S1, P3
cmovge P2, S2
cmp S1, P1
cmovg S1, P1
cmovl P3, P1
cmp S1, P2
cmovl S2, P2
cmovl P2, S1
cmovl S1, S2
cmp P3, P0
mov P1, S1
