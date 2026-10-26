# n=5 model=out iset=I1 prefix14_class=8543
cmp P2, P0
cmovl S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P3, P1
mov S1, P1
cmovl P1, P3
cmovg S1, P3
cmovle P3, S1
cmp P2, S1
cmovle S1, P2
cmovge P3, P2
cmp P0, P1
mov P2, P1
