# n=5 model=out iset=I1 prefix14_class=10591
mov S2, P3
cmp P0, P2
cmovg S1, P0
cmovg P0, P2
cmovg P2, S1
cmp P1, S2
cmovl S2, P1
cmovg P3, P1
cmp P3, P2
cmovle P1, P3
cmovle P3, P2
mov P3, S2
cmovle P2, P1
mov P1, P2
