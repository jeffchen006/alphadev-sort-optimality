# n=5 model=out iset=I1 prefix14_class=4881
cmp P2, P1
cmovle S2, P1
mov S1, P3
cmovle P1, P2
cmovle P2, S2
cmp P0, S1
cmovl P3, P0
cmovle P0, S1
cmp P3, P1
cmovle S0, P3
cmovge S0, P1
cmovl P3, P1
cmp P0, P2
mov P1, P2
