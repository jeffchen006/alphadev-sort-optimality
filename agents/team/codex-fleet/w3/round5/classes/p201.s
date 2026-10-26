# n=5 model=out iset=I1 prefix14_class=201
cmp P0, P2
mov S1, P3
mov S2, P0
cmovle P0, P2
cmovle P2, S2
cmp P3, P1
cmovge S1, P1
mov S2, P0
cmovg P1, P3
cmp S1, P2
cmovle S0, S1
cmovl S1, P2
cmovle P2, S0
cmp S2, P1
