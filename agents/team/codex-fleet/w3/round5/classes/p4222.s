# n=5 model=out iset=I1 prefix14_class=4222
cmp P0, P3
cmovg S1, P0
cmovle S1, P3
cmovl P3, P0
cmp P1, P2
cmovg P0, P2
cmovge P2, P1
cmovg P1, P0
cmp P1, P3
cmovg P0, P3
cmovg P3, P1
cmovle P0, P1
mov P0, P2
cmp S1, P0
