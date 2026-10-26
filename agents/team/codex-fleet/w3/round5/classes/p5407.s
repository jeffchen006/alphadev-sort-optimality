# n=5 model=out iset=I1 prefix14_class=5407
mov S2, P2
cmp P3, P2
cmovge S2, P3
cmovge P3, P2
cmp P0, P1
mov S1, P1
cmovge S1, P0
cmovge P0, P1
cmp P0, P3
cmovl P1, P0
cmovge P1, P3
cmovge P3, P0
cmp S2, S1
cmovg P1, S2
