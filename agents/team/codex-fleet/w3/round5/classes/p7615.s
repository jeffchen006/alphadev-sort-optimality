# n=5 model=out iset=I1 prefix14_class=7615
cmp P0, P1
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
mov S1, P3
cmp P2, P3
cmovl S1, P2
cmovg P3, P2
cmp P1, S1
mov S2, S1
cmovl S2, P1
cmovg S1, P1
cmp P3, P0
mov S2, P0
