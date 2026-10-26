# n=5 model=out iset=I1 prefix14_class=5252
cmp P0, P1
mov S1, P0
cmovg P0, P1
cmovge P1, S1
cmp P3, P2
cmovl S0, P2
cmovle P2, P3
cmovl P3, S0
cmp P0, P2
cmovge S2, P2
cmovl S2, P0
cmovge P2, P0
cmp P3, P1
cmovle S1, P1
