# n=5 model=out iset=I1 prefix14_class=10017
cmp P2, P1
cmovg S1, P1
cmovle S1, P2
cmovge P1, P2
cmp P3, P0
cmovg P2, P0
cmovg P0, P3
cmovg P3, P2
mov P2, S1
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
cmovl P1, S2
cmp P2, P3
