# n=5 model=out iset=I1 prefix14_class=14090
cmp P0, P2
mov S1, P0
cmovle P0, P2
cmovle P2, S1
mov S1, P3
cmp P1, P3
cmovge P3, P1
cmovle S1, P1
cmp P0, P3
cmovl S2, P3
mov P1, P2
cmovle P3, P0
cmovl P0, S2
cmp S1, P1
