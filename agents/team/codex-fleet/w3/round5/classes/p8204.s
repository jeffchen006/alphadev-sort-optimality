# n=5 model=out iset=I1 prefix14_class=8204
cmp P2, P1
cmovg S1, P1
cmovle S1, P2
cmovle P2, P1
mov P1, P0
cmp P0, P3
cmovl P0, P3
cmovle P3, P1
cmovge P1, P3
cmp S1, P3
cmovge P1, S1
cmovge S1, P3
cmp P2, P0
cmovg S2, P0
