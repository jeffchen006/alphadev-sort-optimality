# n=5 model=out iset=I1 prefix14_class=8572
mov S1, P0
cmp P3, P2
cmovle S2, P3
cmovl P3, P2
cmovl P2, S2
cmp P0, P1
cmovg S1, P1
cmovle P0, P1
cmovge P1, P0
cmp P1, P3
cmovge P1, P3
cmovl P0, P3
mov P0, S1
cmp P0, P2
