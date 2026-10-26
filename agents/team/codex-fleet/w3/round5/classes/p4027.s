# n=5 model=out iset=I1 prefix14_class=4027
cmp P1, P2
mov S2, P1
mov S1, P0
cmovge P1, P2
cmovge P2, S2
cmp P3, P0
cmovl S1, P3
cmovg P0, P3
cmovge P3, S1
cmp P1, S1
cmovge P3, P1
cmovl S1, P1
cmp P0, P2
cmovge S1, P2
