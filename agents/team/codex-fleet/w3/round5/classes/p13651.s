# n=5 model=out iset=I1 prefix14_class=13651
cmp P1, P0
mov S1, P0
cmovle P0, P1
cmovge S1, P1
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovl P2, S2
cmp S1, P3
cmovg S0, P3
cmovle S0, S1
cmovl S1, P3
cmp P2, P0
cmovge S1, P0
