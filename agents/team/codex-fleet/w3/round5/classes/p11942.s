# n=5 model=out iset=I1 prefix14_class=11942
mov S2, P2
cmp P2, P0
cmovl S2, P0
cmovl P0, P2
mov S1, P1
cmp P1, P3
cmovl P1, P3
cmovl P3, S1
cmp S2, P1
cmovg S1, S2
cmovg S2, P1
cmovg P1, S1
cmp P3, P0
mov P1, P3
