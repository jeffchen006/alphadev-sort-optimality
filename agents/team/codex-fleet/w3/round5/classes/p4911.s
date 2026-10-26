# n=5 model=out iset=I1 prefix14_class=4911
cmp P1, P2
cmovle S0, P2
cmovge S0, P1
mov S2, P3
cmovl P2, P1
mov S1, P2
cmp P0, P3
cmovl P3, P0
cmovl P0, S2
cmp P2, P3
cmovle P2, P3
cmovg S1, P3
cmp P0, S0
cmovle P1, S0
