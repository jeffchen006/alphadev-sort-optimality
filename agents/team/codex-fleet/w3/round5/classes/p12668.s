# n=5 model=out iset=I1 prefix14_class=12668
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovge S1, P0
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
mov P0, S1
cmovl P3, S2
mov S0, P1
cmp P1, P2
cmovg S0, P2
cmovle P1, P2
cmp P0, P3
