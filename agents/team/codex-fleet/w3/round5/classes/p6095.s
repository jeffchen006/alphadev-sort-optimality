# n=5 model=out iset=I1 prefix14_class=6095
mov S1, P1
cmp P1, P3
cmovle P1, P3
cmovle P3, S1
cmp P2, P0
mov S1, P2
cmovg P2, P0
cmovl S1, P0
cmp S1, P1
cmovg P0, S1
cmovge S1, P1
cmovg P1, P0
mov S2, P3
cmp S2, P2
