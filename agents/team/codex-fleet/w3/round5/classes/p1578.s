# n=5 model=out iset=I1 prefix14_class=1578
mov S0, P0
cmp P0, P3
cmovg P0, P3
mov S2, P1
cmovge P3, S0
cmp P2, S2
cmovg P1, P2
cmovge P2, S2
cmovl S2, P2
cmp P0, S2
cmovl P2, P0
cmovge S2, P0
mov P0, P1
mov P2, S2
