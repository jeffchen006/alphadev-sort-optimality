# n=5 model=out iset=I1 prefix14_class=8696
mov S1, P3
cmp P3, P2
cmovg S1, P2
cmovle P3, P2
cmp P1, P0
mov S2, P3
cmovle P2, P0
cmovle P0, P1
cmovl P1, P2
cmp P1, P3
cmovg P3, P1
cmovl S2, P1
mov P1, P0
cmp P0, S1
