# n=5 model=out iset=I1 prefix14_class=4467
cmp P3, P0
cmovle S1, P3
cmovg S1, P0
cmovl P3, P0
mov S2, P2
cmp P2, P1
cmovl S2, P1
cmovle P1, P2
cmp P3, S2
mov S0, P3
cmovge S0, S2
cmovge S2, P3
cmp P1, S1
cmovle P2, S1
