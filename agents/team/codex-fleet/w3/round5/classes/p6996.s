# n=5 model=out iset=I1 prefix14_class=6996
cmp P3, P0
cmovge S2, P0
cmovg P0, P3
mov S1, P2
cmovle S2, P3
cmp P1, P2
cmovl S1, P1
cmovle P1, P2
cmp S2, S1
cmovle P2, S1
cmovle S1, S2
cmovg P2, S2
cmp P0, P1
cmovge S0, P0
