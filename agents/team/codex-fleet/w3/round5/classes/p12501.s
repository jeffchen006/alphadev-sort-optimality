# n=5 model=out iset=I1 prefix14_class=12501
cmp P1, P0
cmovle S0, P1
cmovl P1, P0
cmovle P0, S0
cmp P3, P2
cmovge S2, P2
cmovle S2, P3
cmovg P2, P3
mov P3, P0
cmp P0, S2
cmovl P3, S2
cmovle S2, P0
cmp P2, P1
mov S2, P2
