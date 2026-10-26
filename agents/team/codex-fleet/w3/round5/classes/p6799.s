# n=5 model=out iset=I1 prefix14_class=6799
cmp P3, P2
cmovle S2, P3
cmovl P3, P2
cmovle P2, S2
cmp P0, P1
mov S0, P0
cmovl P0, P1
cmovg S0, P1
cmp P3, P0
cmovge S1, P0
cmovg P0, P3
cmovle S1, P3
cmp P2, S0
cmovl P1, P2
