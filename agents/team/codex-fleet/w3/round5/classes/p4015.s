# n=5 model=out iset=I1 prefix14_class=4015
cmp P3, P2
mov S1, P3
cmovle P3, P2
cmovg S1, P2
cmp P1, P0
cmovl S0, P0
cmovle P0, P1
mov S2, S1
cmovge S0, P1
cmp S2, P0
cmovle S1, P0
cmovge S2, P0
cmp S0, P3
cmovle P2, S0
