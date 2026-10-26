# n=5 model=out iset=I1 prefix14_class=3
mov S1, P0
cmp P1, P0
cmovl P0, P1
cmovle P1, S1
mov S2, P3
cmp P2, P3
cmovl S2, P2
cmovg P3, P2
mov S1, P1
mov P2, P0
cmp P0, S2
cmovg P0, S2
cmovg S2, P2
mov P2, S2
