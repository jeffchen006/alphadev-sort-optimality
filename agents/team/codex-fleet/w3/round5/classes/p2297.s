# n=5 model=out iset=I1 prefix14_class=2297
mov S1, P3
cmp P3, P0
cmovg S1, P0
cmovl P3, P0
mov P0, P2
cmp P2, P1
cmovl P0, P1
cmovge P2, P1
cmp P0, P3
cmovle P1, P3
cmovle P3, P0
cmovg P1, P0
cmp S1, P2
cmovl P1, S1
