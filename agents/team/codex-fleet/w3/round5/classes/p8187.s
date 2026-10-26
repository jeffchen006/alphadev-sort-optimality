# n=5 model=out iset=I1 prefix14_class=8187
mov S2, P0
cmp P3, P1
cmovl S1, P1
cmovle P1, P3
cmovl P3, S1
cmp P2, P0
cmovle P0, P2
cmovle P2, S2
cmp P1, P0
cmovg S1, P0
cmovg P0, P1
cmovg P1, S1
cmp P2, P3
mov P1, P2
