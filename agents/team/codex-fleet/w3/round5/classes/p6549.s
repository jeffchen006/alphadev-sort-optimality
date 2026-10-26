# n=5 model=out iset=I1 prefix14_class=6549
cmp P2, P0
cmovge S0, P2
cmovle S0, P0
cmovl P0, P2
cmovg P2, P0
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp S0, P3
mov S2, P3
cmovl S2, S0
cmovge P3, S0
cmp P0, P1
