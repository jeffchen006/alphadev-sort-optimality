# n=5 model=out iset=I1 prefix14_class=4072
cmp P0, P1
cmovl S1, P0
cmovle P0, P1
mov S2, P3
cmovl P1, S1
cmp P2, S2
cmovg P3, P2
cmovg P2, S2
cmp P2, P1
cmovle S0, P2
cmovge S0, P1
cmovle P2, P1
cmp P3, P0
mov P1, P3
