# n=5 model=out iset=I1 prefix14_class=13778
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
cmovg P1, S1
cmp P0, P2
mov S2, P0
cmovg S2, P2
cmovg P2, P0
cmp P1, P2
cmovl P0, P1
cmovle P1, P2
mov P1, P3
cmovl P2, P0
cmp S2, P1
