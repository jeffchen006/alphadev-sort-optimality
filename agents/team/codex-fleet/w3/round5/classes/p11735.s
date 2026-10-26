# n=5 model=out iset=I1 prefix14_class=11735
mov S0, P2
cmp P0, S0
cmovge S0, P0
cmovl P2, P0
mov S2, S0
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
cmovg P1, S1
cmp S2, P1
cmovge S2, P1
cmovle S0, P1
cmp P2, P3
cmovl S1, P3
