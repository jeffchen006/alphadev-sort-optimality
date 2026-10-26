# n=5 model=out iset=I1 prefix14_class=3342
mov S0, P0
cmp P2, P1
cmovge S1, P1
cmovge P1, P2
cmovl S1, P2
cmp P3, P0
cmovge S0, P3
cmovl P0, P3
cmp S1, P0
cmovge S2, P0
cmovle S2, S1
cmovg P0, S1
cmp P1, S0
cmovle S1, P1
