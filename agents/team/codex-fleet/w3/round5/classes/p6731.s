# n=5 model=out iset=I1 prefix14_class=6731
cmp P1, P2
mov S1, P2
cmovge P2, P1
cmovge P1, S1
mov S1, P3
cmp P3, P0
cmovl S1, P0
cmovge P3, P0
cmp P2, S1
cmovge P0, P2
cmovge P2, S1
cmovge S1, P0
cmp P1, P3
cmovge S2, P1
