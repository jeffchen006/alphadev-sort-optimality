# n=5 model=out iset=I1 prefix14_class=11017
cmp P2, P3
cmovge S0, P2
cmovg P2, P3
mov S1, P0
cmovl S0, P3
cmp P1, S1
cmovle S1, P1
cmovge P0, P1
cmp P0, S0
cmovle S2, P0
cmovl P0, S0
cmovl S0, S2
cmp P2, S1
cmovle S2, S1
