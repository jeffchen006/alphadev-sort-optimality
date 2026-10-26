# n=5 model=out iset=I1 prefix14_class=4897
cmp P1, P0
cmovle S1, P1
cmovle P1, P0
cmovle P0, S1
cmovge S1, P0
mov S2, P3
cmp P2, S2
cmovl S2, P2
cmovle P2, P3
cmp S2, P0
cmovg S1, S2
cmovge S2, P0
cmp P1, P2
cmovge S0, P2
