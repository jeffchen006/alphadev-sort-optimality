# n=5 model=out iset=I1 prefix14_class=11439
cmp P0, P1
mov S2, P1
cmovge S2, P0
cmovle P1, P0
cmp P3, P2
cmovg S1, P2
cmovle S1, P3
cmovl P3, P2
cmp P1, S1
cmovge P0, P1
cmovg P1, S1
mov P1, S2
cmovg S1, P0
cmp P1, P3
