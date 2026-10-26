# n=5 model=out iset=I1 prefix14_class=5093
cmp P3, P2
mov S1, P0
cmovle S2, P3
cmovge S2, P2
cmovle P3, P2
cmp P1, S1
cmovg S1, P1
cmovg P1, P0
cmp S2, P1
cmovge S0, S2
cmovle S0, P1
cmovl P1, S2
cmp S1, P3
cmovl P1, P3
