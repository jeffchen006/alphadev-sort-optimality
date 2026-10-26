# n=5 model=out iset=I1 prefix14_class=6879
cmp P2, P0
cmovle S1, P2
cmovl P2, P0
cmovge S1, P0
mov P0, P1
mov S2, P2
cmp P1, P3
cmovge P1, P3
cmovle P0, P3
cmp P0, P2
cmovg S2, P0
cmovle P2, P0
cmp P1, S1
cmovge P3, P1
