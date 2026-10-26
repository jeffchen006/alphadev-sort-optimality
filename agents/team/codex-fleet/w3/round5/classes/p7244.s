# n=5 model=out iset=I1 prefix14_class=7244
cmp P2, P0
mov S1, P0
cmovg P0, P2
cmovle S1, P2
mov P2, P1
cmp P1, P3
cmovl P2, P3
cmovl P3, P1
mov P1, P3
cmp P3, S1
cmovle P1, S1
cmovg P3, S1
cmp P2, P0
cmovge S0, P0
