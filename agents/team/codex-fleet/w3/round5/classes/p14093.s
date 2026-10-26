# n=5 model=out iset=I1 prefix14_class=14093
mov S1, P0
cmp S1, P2
cmovle S1, P2
cmovl P2, P0
cmp P3, P1
cmovg P0, P1
cmovle P0, P3
cmovge P1, P3
mov S2, P2
cmp S1, P1
cmovl S0, P1
cmovl P1, S1
cmovl S1, S0
cmp P0, S2
