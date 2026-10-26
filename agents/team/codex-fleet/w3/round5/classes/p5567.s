# n=5 model=out iset=I1 prefix14_class=5567
mov S0, P2
mov S1, P3
cmp P3, P0
cmovle P3, P0
cmovg S1, P0
cmp P2, P1
cmovl P2, P1
cmovle P1, S0
cmp P1, S1
cmovl S2, S1
cmovle S1, P1
cmovge S2, P1
cmp P3, P2
cmovle P0, P3
