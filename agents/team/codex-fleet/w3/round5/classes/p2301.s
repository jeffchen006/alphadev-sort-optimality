# n=5 model=out iset=I1 prefix14_class=2301
mov S1, P3
cmp P3, P1
cmovge S1, P1
cmovle P3, P1
cmp P0, P2
mov P1, P0
cmovge P0, P2
cmovl P1, P2
cmp P1, P3
cmovle P2, P3
cmovle P3, P1
cmovg P2, P1
cmp S1, P0
cmovle P2, S1
