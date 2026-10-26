# n=5 model=out iset=I1 prefix14_class=4520
mov S2, P3
cmp P3, P0
cmovg P3, P0
cmovl S2, P0
mov S1, P1
cmp P1, P2
cmovle P1, P2
cmovg S1, P2
mov P2, P1
cmp P2, S2
cmovg P1, S2
cmovg S2, P2
cmp S1, P3
cmovle P0, S1
