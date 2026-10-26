# n=5 model=out iset=I1 prefix14_class=5767
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
cmovge P3, S0
mov S1, P3
mov S2, P0
cmp P1, P0
cmovge S2, P1
cmovl P0, P1
cmp P0, P3
cmovg P3, P0
cmovl S1, P0
cmp P2, S2
mov S1, P2
