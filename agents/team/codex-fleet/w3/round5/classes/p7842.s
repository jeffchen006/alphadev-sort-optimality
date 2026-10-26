# n=5 model=out iset=I1 prefix14_class=7842
mov S2, P3
cmp P3, P2
cmovge S2, P2
cmovle P3, P2
mov P2, S2
cmp P0, P1
cmovle S0, P1
cmovl P1, P0
cmovl P0, S0
cmp P1, S2
cmovle S2, P1
cmovg P2, P1
cmp P3, P0
cmovl S1, P0
