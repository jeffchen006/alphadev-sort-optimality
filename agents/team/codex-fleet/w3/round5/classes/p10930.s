# n=5 model=out iset=I1 prefix14_class=10930
cmp P1, P3
cmovle S2, P3
cmovle P3, P1
cmovle P1, S2
mov S1, P2
cmp P0, P2
cmovle P2, P0
cmovg S1, P0
cmp S1, P1
cmovl S0, P1
cmovge S0, S1
cmovl P1, S1
cmp P3, P2
cmovle S1, P2
