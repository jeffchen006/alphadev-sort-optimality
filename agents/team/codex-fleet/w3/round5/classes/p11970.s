# n=5 model=out iset=I1 prefix14_class=11970
cmp P2, P0
cmovge S2, P0
cmovge P0, P2
mov S1, P3
cmovge P2, S2
cmp P1, S1
cmovge S1, P1
cmovl P3, P1
mov P1, S1
cmp P2, P3
cmovl S0, P3
cmovge S0, P2
cmovg P2, P3
mov P2, S0
