# n=5 model=out iset=I1 prefix14_class=2234
cmp P3, P1
mov S1, P1
cmovg P1, P3
cmovg P3, S1
cmp P0, P2
mov S1, P2
cmovg S1, P0
cmovge P0, P2
mov S2, P1
cmp P1, S1
cmovl P1, S1
cmovl S1, S2
cmp P3, P0
cmovl S2, P3
