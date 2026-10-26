# n=5 model=out iset=I1 prefix14_class=11480
mov S2, P3
cmp S2, P1
cmovl S2, P1
cmovl P1, P3
cmp P0, P2
cmovg S1, P0
cmovg P0, P2
mov P3, P0
cmovg P2, S1
cmp P3, P1
cmovle P0, P1
cmovl P1, P3
mov P1, S2
cmp P2, S2
