# n=5 model=out iset=I1 prefix14_class=5956
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmovge S1, P1
mov P1, P3
cmp P1, P0
cmovge P3, P0
cmovle P1, P0
mov P0, S1
cmp P0, P1
cmovl P0, P1
cmovg S1, P1
cmp P3, P2
cmovle P1, P2
