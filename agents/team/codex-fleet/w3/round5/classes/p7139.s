# n=5 model=out iset=I1 prefix14_class=7139
cmp P1, P2
cmovge S2, P2
cmovl S2, P1
mov S1, P0
cmovl P1, P2
cmp P0, P3
cmovle P0, P3
cmovge S1, P3
cmp S1, S2
mov S0, S2
cmovl S2, S1
cmovle S1, S0
cmp P0, P1
cmovle S0, P1
