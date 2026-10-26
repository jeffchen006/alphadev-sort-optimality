# n=5 model=out iset=I1 prefix14_class=8281
mov S2, P3
cmp P1, P2
cmovg S1, P2
cmovle S1, P1
cmovl P1, P2
cmovle P2, S1
cmp P0, S2
cmovle P3, P0
cmovg S2, P0
cmp P2, P3
cmovle S1, P3
cmovge P2, P3
cmovge P3, S1
mov P2, S2
