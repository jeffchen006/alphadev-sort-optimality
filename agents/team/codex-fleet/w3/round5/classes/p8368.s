# n=5 model=out iset=I1 prefix14_class=8368
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
mov S2, P0
cmovle P3, S1
mov S0, P3
cmp P2, S2
cmovl S2, P2
cmovl P2, P0
cmp P3, S2
cmovg S0, S2
cmovl P3, S2
cmovge S2, P3
cmp P1, P2
