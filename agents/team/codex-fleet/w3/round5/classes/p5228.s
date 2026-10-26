# n=5 model=out iset=I1 prefix14_class=5228
mov S0, P2
mov S1, P1
cmp P2, P3
cmovg P2, P3
cmovl S0, P3
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmp P2, S1
mov S2, P2
cmovl P2, S1
cmovge S2, S1
cmp P0, S0
cmovge S1, P0
