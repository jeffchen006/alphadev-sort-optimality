# n=5 model=out iset=I1 prefix14_class=13815
cmp P2, P3
cmovge S1, P2
cmovge P2, P3
cmovl S1, P3
cmp P1, P0
mov P3, P0
cmovge P3, P1
cmovl P0, P1
cmp P3, S1
mov S2, P0
cmovge P1, S1
cmovge S1, P3
cmovge P3, P1
mov S1, P3
