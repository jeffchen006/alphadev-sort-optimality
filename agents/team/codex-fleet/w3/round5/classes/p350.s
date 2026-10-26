# n=5 model=out iset=I1 prefix14_class=350
mov S1, P2
cmp S1, P0
cmovg P2, P0
cmovg P0, S1
mov S1, P3
cmp S1, P1
cmovge S1, P1
cmovg P1, P3
cmp P2, S1
cmovge P3, S1
cmovle P3, P2
cmovl P2, S1
cmp P1, P0
mov S2, P2
