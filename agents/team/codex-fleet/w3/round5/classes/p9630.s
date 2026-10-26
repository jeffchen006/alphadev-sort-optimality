# n=5 model=out iset=I1 prefix14_class=9630
cmp P0, P2
cmovge S2, P2
cmovge P2, P0
mov S1, P1
cmovge P0, S2
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
mov P1, S1
cmp P1, P2
cmovge S1, P2
cmovl P1, P2
cmp P0, P3
cmovge S2, P0
