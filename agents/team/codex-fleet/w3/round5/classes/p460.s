# n=5 model=out iset=I1 prefix14_class=460
cmp P2, P1
cmovl S1, P1
cmovl P1, P2
cmovge S1, P2
cmp P3, P0
mov S2, P3
cmovg P3, P0
cmovge P0, S2
mov S0, S1
mov P2, P1
cmp P3, P1
cmovl P1, P3
cmovl P3, P2
mov P1, P3
