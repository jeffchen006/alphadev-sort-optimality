# n=5 model=out iset=I1 prefix14_class=11507
mov S1, P0
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovl P2, S2
cmp P0, P1
cmovg S1, P1
cmovle P0, P1
cmp P2, S1
mov P1, P2
cmovle P2, S1
cmovl S1, P1
cmp P3, P0
cmovge S1, P3
