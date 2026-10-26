# n=5 model=out iset=I1 prefix14_class=13496
cmp P1, P0
cmovg S1, P1
cmovle S1, P0
cmovle P0, P1
cmp P2, P3
cmovl P1, P3
cmovge P1, P2
cmovle P3, P2
cmp P3, P0
cmovle P2, P0
cmovl P0, P3
cmovle P3, P2
mov P0, P1
cmp S1, P1
