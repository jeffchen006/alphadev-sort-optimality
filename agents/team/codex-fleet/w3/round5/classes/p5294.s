# n=5 model=out iset=I1 prefix14_class=5294
cmp P1, P2
mov S2, P1
mov S1, P0
cmovg P1, P2
cmovge P2, S2
cmp P0, P3
cmovge S1, P3
cmovle P0, P3
mov P3, S1
cmp S1, P1
cmovl P3, P1
cmovle P1, S1
mov P1, P3
cmp P0, P2
