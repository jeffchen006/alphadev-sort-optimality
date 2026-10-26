# n=5 model=out iset=I1 prefix14_class=13627
cmp P2, P0
cmovge S2, P2
cmovl S2, P0
cmovl P0, P2
cmp P3, P1
mov S1, P1
cmovge S1, P3
cmovge P3, P1
cmp P0, P3
cmovge P2, P3
cmovge P3, P0
cmovge P0, P2
cmp S1, S2
mov P0, S2
