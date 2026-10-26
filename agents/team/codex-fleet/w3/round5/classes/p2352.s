# n=5 model=out iset=I1 prefix14_class=2352
cmp P0, P1
mov S1, P0
cmovl P0, P1
cmovle P1, S1
cmp P2, P3
cmovge S1, P2
cmovg P2, P3
cmovle S1, P3
cmp P0, S1
mov P3, S1
cmovg S1, P0
cmovl P3, P0
cmp P1, P2
cmovge S2, P1
