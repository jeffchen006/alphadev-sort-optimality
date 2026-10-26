# n=5 model=out iset=I1 prefix14_class=4159
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmovle S1, P1
cmp P3, P0
mov S2, P3
cmovle S2, P0
mov P1, S1
cmovle P0, P3
cmp P0, P1
cmovg S1, P0
cmovl P1, P0
cmp P2, S2
cmovle P3, S2
