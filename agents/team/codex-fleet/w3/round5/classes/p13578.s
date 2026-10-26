# n=5 model=out iset=I1 prefix14_class=13578
cmp P0, P2
cmovge S2, P0
cmovle S2, P2
cmovg P0, P2
mov S1, P3
cmp S1, P1
cmovl P3, P1
cmovge S1, P1
cmp S1, P0
mov S0, P0
cmovl P0, S1
cmovge S0, S1
cmp P3, S2
cmovle S1, S0
