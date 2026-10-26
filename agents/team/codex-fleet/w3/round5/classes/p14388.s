# n=5 model=out iset=I1 prefix14_class=14388
mov S1, P2
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
mov S2, P0
cmovle P1, S0
cmp S1, P3
cmovle P2, P3
cmovge S1, P3
cmp S2, S1
cmovg P0, S1
cmovl S2, S1
mov P0, P1
cmp P2, P0
