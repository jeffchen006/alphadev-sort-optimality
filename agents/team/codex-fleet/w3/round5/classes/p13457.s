# n=5 model=out iset=I1 prefix14_class=13457
cmp P0, P2
cmovle S0, P2
cmovge S0, P0
cmovl P2, P0
cmp P1, P3
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
mov S2, P3
cmp S2, P2
cmovl S2, P2
cmovle P2, P3
cmp P1, S0
cmovg S1, S0
