# n=5 model=out iset=I1 prefix14_class=1615
mov S1, P1
cmp P0, P2
mov S2, P0
cmovle S2, P2
cmovg P0, P2
cmp P3, S1
cmovl S1, P3
cmovg P1, P3
cmovge P3, S1
cmp P0, S1
cmovl P3, P0
cmovl P0, S1
cmp S2, P1
cmovg P2, P1
