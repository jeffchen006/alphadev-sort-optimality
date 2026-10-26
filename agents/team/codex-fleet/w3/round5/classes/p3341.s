# n=5 model=out iset=I1 prefix14_class=3341
mov S0, P1
cmp P2, P0
cmovge S2, P0
cmovl S2, P2
cmovge P0, P2
cmp P3, P1
cmovge S0, P3
cmovl P1, P3
cmp S2, P1
cmovge S1, P1
cmovle S1, S2
cmovg P1, S2
cmp P0, S0
cmovle S2, P0
