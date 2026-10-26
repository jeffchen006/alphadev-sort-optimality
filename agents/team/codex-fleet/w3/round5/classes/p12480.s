# n=5 model=out iset=I1 prefix14_class=12480
mov S1, P0
cmp P2, P0
cmovg S1, P2
mov S2, P1
cmovl P0, P2
cmp P3, P1
cmovge S2, P3
cmovg P3, P1
mov P2, P0
cmp P3, P0
cmovle P0, P3
cmovg P2, P3
cmp S2, S1
cmovge P0, S2
