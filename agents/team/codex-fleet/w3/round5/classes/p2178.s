# n=5 model=out iset=I1 prefix14_class=2178
cmp P0, P1
mov S1, P1
cmovg S1, P0
cmovg P0, P1
cmp P2, P3
cmovl P1, P3
cmovle P3, P2
mov S2, S1
cmovl P2, P1
cmp P2, S1
cmovl S2, P2
cmovg S1, P2
cmp P3, P0
mov P2, P0
