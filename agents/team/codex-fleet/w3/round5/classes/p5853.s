# n=5 model=out iset=I1 prefix14_class=5853
mov S1, P3
cmp P2, P1
cmovge S2, P2
cmovg P2, P1
cmovle S2, P1
cmp S1, P0
mov S0, S2
cmovle P3, P0
cmovg S1, P0
cmp S1, P2
cmovle P1, S1
cmovl S1, P2
cmovle P2, P1
cmp S0, P3
