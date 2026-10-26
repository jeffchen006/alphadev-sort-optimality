# n=5 model=out iset=I1 prefix14_class=8030
mov S1, P2
cmp S1, P1
cmovg P2, P1
cmovl S1, P1
mov S2, P0
cmp P0, P3
cmovle P0, P3
cmovg S2, P3
cmp S2, P2
cmovle S0, P2
cmovle P2, S2
cmovle S2, S0
cmp S1, P0
cmovge S0, P0
