# n=5 model=out iset=I1 prefix14_class=6431
cmp P3, P2
mov S0, P2
cmovl S0, P3
cmovg P2, P3
cmp P1, P0
mov S1, P0
cmovg P0, P1
cmovl S1, P1
cmp P0, P2
mov S2, P2
cmovle P2, P0
cmovge S2, P0
cmp S1, S0
cmovle P0, S0
