# n=5 model=out iset=I1 prefix14_class=13615
mov S1, P3
mov S2, P1
cmp S1, P2
cmovl S1, P2
cmovl P2, P3
cmp P0, S2
cmovl S2, P0
cmovge P1, P0
cmp S2, P2
cmovge S0, P2
cmovg P2, S2
mov P3, S1
cmovg S2, S0
cmp P1, S1
