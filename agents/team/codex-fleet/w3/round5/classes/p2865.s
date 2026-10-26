# n=5 model=out iset=I1 prefix14_class=2865
mov S2, P0
cmp P3, P0
cmovge S2, P3
cmovl P0, P3
cmp P2, P1
cmovge S1, P2
cmovle S1, P1
cmovg P2, P1
mov S0, S1
cmp S2, S1
cmovle S1, S2
cmovg S0, S2
cmp P0, P2
cmovl P1, P0
