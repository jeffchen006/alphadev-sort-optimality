# n=5 model=out iset=I1 prefix14_class=33
mov S1, P0
cmp P1, S1
cmovl P0, P1
cmovl P1, S1
cmp P3, P2
mov S2, P3
cmovge P3, P2
cmovg P2, S2
mov S1, P0
cmp P0, P3
cmovge P0, P3
cmovl S1, P3
mov P3, P1
cmp P1, P2
