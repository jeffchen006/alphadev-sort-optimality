# n=5 model=out iset=I1 prefix14_class=11950
cmp P2, P0
mov S1, P1
mov S2, P2
cmovle S2, P0
cmovl P0, P2
cmp S1, P3
cmovl S1, P3
cmovl P3, P1
cmp S2, S1
cmovg S0, S2
cmovge S2, S1
cmovg S1, S0
cmp P3, P0
cmovle P1, P3
