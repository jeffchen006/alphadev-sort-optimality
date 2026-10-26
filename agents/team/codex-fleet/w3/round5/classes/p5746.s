# n=5 model=out iset=I1 prefix14_class=5746
cmp P2, P1
cmovge S2, P2
cmovl S2, P1
mov S0, S2
mov S1, P3
cmovg P2, P1
cmp P0, P3
cmovg P3, P0
cmovl S1, P0
cmp S1, P2
mov P0, S1
cmovl P0, P2
cmovl P2, S1
mov P2, P0
