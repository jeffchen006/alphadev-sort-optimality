# n=5 model=out iset=I1 prefix14_class=5854
mov S1, P3
cmp P2, P0
cmovge S2, P2
cmovle S2, P0
cmovg P2, P0
cmp P3, P1
mov S0, S2
cmovle P3, P1
cmovg S1, P1
cmp S1, P2
cmovle P0, S1
cmovl S1, P2
cmovle P2, P0
cmp S0, P3
