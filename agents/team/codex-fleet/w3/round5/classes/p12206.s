# n=5 model=out iset=I1 prefix14_class=12206
mov S2, P2
cmp P0, P2
cmovl P2, P0
cmovg S2, P0
cmp P1, P3
cmovl S1, P3
mov P0, P2
cmovl P3, P1
cmovl P1, S1
cmp P0, P3
cmovg P0, P3
cmovg P3, P2
cmp P1, S2
mov P0, S2
