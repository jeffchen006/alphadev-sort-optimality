# n=5 model=out iset=I1 prefix14_class=7930
cmp P3, P0
mov S2, P1
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P1, P2
cmovge P1, P2
cmovge P2, S2
cmovg S2, P1
cmp P0, P1
cmovg S2, P0
cmovle P1, P0
mov P0, P2
cmp P0, P3
