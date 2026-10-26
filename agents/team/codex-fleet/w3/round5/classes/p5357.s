# n=5 model=out iset=I1 prefix14_class=5357
mov S2, P3
cmp P2, P0
cmovge S1, P0
cmovg P0, P2
cmovl S1, P2
cmp P1, P3
cmovle S2, P1
cmovge P3, P1
cmp S1, S2
cmovge P1, S1
cmovl P1, S2
cmovle S2, S1
cmp P3, P0
cmovge S0, P0
