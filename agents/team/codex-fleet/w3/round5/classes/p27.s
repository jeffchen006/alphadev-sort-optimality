# n=5 model=out iset=I1 prefix14_class=27
mov S1, P0
cmp P3, S1
cmovl P0, P3
cmovl P3, S1
cmp P2, P1
cmovge S2, P2
cmovge P2, P1
mov S1, P0
cmovge P1, S2
cmp S1, P2
cmovl S1, P2
cmovge P0, P2
mov P2, P1
cmp P1, P3
