# n=5 model=out iset=I1 prefix14_class=1276
mov S1, P0
mov S2, P1
cmp P1, P2
cmovle P1, P2
cmovg S2, P2
cmovg P2, P1
cmp P0, P3
cmovl P0, P3
cmovl P3, S1
cmp P2, P0
cmovge P1, P0
cmovle P2, P0
mov P0, S2
cmp S2, P3
