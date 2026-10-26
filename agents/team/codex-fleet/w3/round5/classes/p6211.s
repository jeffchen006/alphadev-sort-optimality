# n=5 model=out iset=I1 prefix14_class=6211
cmp P0, P2
cmovge S2, P2
cmovl S2, P0
mov S1, P3
cmovle P0, P2
cmp P1, S1
cmovle S1, P1
cmovg P3, P1
cmp P3, P0
cmovle S0, P3
cmovle P3, P0
mov P1, S1
cmovl P0, S0
cmp P1, S2
