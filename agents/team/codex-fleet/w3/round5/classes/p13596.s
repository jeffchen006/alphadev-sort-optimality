# n=5 model=out iset=I1 prefix14_class=13596
mov S0, P3
cmp P2, P1
cmovle S1, P1
cmovge S1, P2
cmovle P1, P2
cmp P0, S0
cmovl P3, P0
cmovle P0, S0
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
mov S0, P0
cmovle P3, S2
mov P1, P3
