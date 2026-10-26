# n=5 model=out iset=I1 prefix14_class=10064
cmp P3, P2
mov S1, P1
cmovle S2, P3
cmovle P3, P2
cmovl P2, S2
cmp P0, S1
cmovle P1, P0
cmovl P0, S1
cmovge S1, P0
cmp P3, S1
cmovg S1, P3
cmovg P3, P0
cmp P2, P1
cmovl S1, P1
