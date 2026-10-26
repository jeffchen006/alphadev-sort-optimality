# n=5 model=out iset=I1 prefix14_class=6477
mov S2, P3
cmp P0, P1
mov S1, P0
cmovle P0, P1
cmovle P1, S1
cmp P2, S2
cmovge S2, P2
cmovl P3, P2
cmp P0, S2
cmovle S0, P0
cmovle P0, S2
cmovg S0, S2
cmp P3, P1
cmovle S2, P1
