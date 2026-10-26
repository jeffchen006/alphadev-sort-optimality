# n=5 model=out iset=I1 prefix14_class=8956
cmp P1, P3
cmovl S1, P3
cmovge S1, P1
cmovg P1, P3
cmp P0, P2
mov S0, P0
cmovle P0, P2
cmovl P2, S0
cmp P0, S1
mov S2, P0
cmovle S2, S1
cmovg P0, S1
cmp P1, P2
cmovge P3, P1
