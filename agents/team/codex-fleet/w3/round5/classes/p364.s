# n=5 model=out iset=I1 prefix14_class=364
mov S2, P2
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
mov S1, P3
cmp P3, P0
cmovg P3, P0
cmovg P0, S1
mov P2, P1
cmp P3, P2
mov S1, P0
cmovle P1, P3
cmovl P3, P2
cmp S2, S1
