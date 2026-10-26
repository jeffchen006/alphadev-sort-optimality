# n=5 model=out iset=I1 prefix14_class=14315
cmp P2, P0
mov S2, P3
cmovl S0, P0
cmovl P0, P2
cmovl P2, S0
cmp P1, P3
cmovg S2, P1
cmovge P1, P3
cmp P0, P1
mov P3, P1
cmovge P3, P0
cmovg P0, P1
cmp P2, S2
cmovge S1, P2
