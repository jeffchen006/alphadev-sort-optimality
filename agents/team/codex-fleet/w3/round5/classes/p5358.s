# n=5 model=out iset=I1 prefix14_class=5358
mov S0, P3
cmp P2, P0
cmovge S1, P0
cmovg P0, P2
cmovle S1, P2
cmp P1, P3
cmovle S0, P1
cmovge P3, P1
cmp S1, S0
mov P1, S1
cmovl P1, S0
cmovl S0, S1
cmp P0, P3
cmovge S2, P3
