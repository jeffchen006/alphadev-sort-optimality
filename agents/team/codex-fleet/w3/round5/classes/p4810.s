# n=5 model=out iset=I1 prefix14_class=4810
mov S2, P3
cmp P1, P3
cmovg S2, P1
cmovle P3, P1
cmp P0, P2
cmovg P1, P0
cmovg P0, P2
cmovg P2, P1
mov S1, P0
cmp P3, S1
cmovl P0, P3
cmovge S1, P3
cmp S2, P2
mov P3, P2
