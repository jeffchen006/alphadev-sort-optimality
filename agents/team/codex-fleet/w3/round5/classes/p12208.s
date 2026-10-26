# n=5 model=out iset=I1 prefix14_class=12208
mov S2, P2
cmp P0, S2
cmovl P2, P0
cmovg S2, P0
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
mov P0, P2
cmovl P3, S1
cmp P0, P1
cmovg P0, P1
cmovg P1, P2
cmp P3, S2
cmovle P0, S2
