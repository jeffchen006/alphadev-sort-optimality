# n=5 model=out iset=I1 prefix14_class=1870
mov S2, P3
cmp P1, P3
mov S1, P2
cmovle P3, P1
cmovle P1, S2
cmp P0, S1
cmovle P2, P0
cmovge S1, P0
mov S2, P1
cmp S1, S2
cmovl P1, S1
cmovle S1, S2
cmp P3, P2
cmovl S0, P3
