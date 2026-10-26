# n=5 model=out iset=I1 prefix14_class=14039
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
mov S1, P3
cmovge P0, S2
cmp S1, P1
cmovg P3, P1
cmovl S1, P1
cmp P0, S1
cmovl P1, S1
cmovl S1, P0
mov S2, S1
cmovl P0, P1
mov S0, P3
