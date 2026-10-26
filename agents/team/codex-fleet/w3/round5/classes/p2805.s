# n=5 model=out iset=I1 prefix14_class=2805
mov S1, P1
cmp P1, P0
mov S2, P3
cmovg P1, P0
cmovg P0, S1
cmp P2, P3
cmovl P3, P2
cmovl P2, S2
mov S1, P1
cmp P2, P0
cmovg S2, P0
cmovg P0, P2
cmovg P2, S2
cmp P1, P3
