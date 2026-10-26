# n=5 model=out iset=I1 prefix14_class=5313
cmp P2, P3
cmovge S1, P3
cmovg P3, P2
mov S0, P0
cmovle S1, P2
cmp P0, P1
cmovl P0, P1
cmovge S0, P1
mov S2, S0
cmp S2, S1
cmovl S0, S1
cmovle S1, S2
cmp P0, P3
cmovge S2, P0
