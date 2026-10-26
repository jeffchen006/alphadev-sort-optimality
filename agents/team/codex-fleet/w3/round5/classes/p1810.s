# n=5 model=out iset=I1 prefix14_class=1810
cmp P0, P3
cmovg S1, P3
cmovg P3, P0
mov S2, P1
cmovg P0, S1
cmp P2, S2
cmovg S2, P2
cmovg P2, P1
cmp P3, S2
mov S1, P3
cmovl P3, S2
cmovg S1, S2
cmp P2, P0
cmovg P1, P0
