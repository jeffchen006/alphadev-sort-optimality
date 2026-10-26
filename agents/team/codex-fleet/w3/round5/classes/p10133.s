# n=5 model=out iset=I1 prefix14_class=10133
cmp P3, P0
cmovge S0, P0
cmovle S0, P3
cmovg P0, P3
mov S1, P0
cmp P2, P1
cmovle S2, P2
cmovg S2, P1
cmovg P1, P2
cmp P1, S1
cmovle P0, P1
cmovle P1, S1
cmp S2, S0
cmovl S1, S0
