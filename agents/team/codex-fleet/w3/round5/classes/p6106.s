# n=5 model=out iset=I1 prefix14_class=6106
cmp P1, P3
cmovle S1, P3
cmovge S1, P1
cmovl P3, P1
cmp P2, P0
cmovge S2, P2
cmovle S2, P0
cmovg P2, P0
mov P1, S2
cmp P1, S1
cmovg S2, S1
cmovg S1, P1
cmp P2, P3
cmovle S1, P2
