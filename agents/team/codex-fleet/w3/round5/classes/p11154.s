# n=5 model=out iset=I1 prefix14_class=11154
cmp P3, P1
cmovl S1, P3
mov S2, P2
cmovl P3, P1
cmovl P1, S1
cmp P2, P0
cmovg S2, P0
cmovle P2, P0
mov P0, P3
cmp P2, P3
cmovle P0, P2
cmovle P2, P3
cmp P1, S2
cmovg S1, S2
