# n=5 model=out iset=I1 prefix14_class=14429
mov S1, P2
cmp S1, P3
cmovle P2, P3
cmovge S1, P3
mov S2, P1
cmp P0, P1
cmovl S2, P0
cmovg P1, P0
mov P0, S2
cmp P0, S1
cmovge P0, S1
cmovl S2, P1
cmovge S1, S2
cmp P2, P1
