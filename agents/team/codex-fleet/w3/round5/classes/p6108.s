# n=5 model=out iset=I1 prefix14_class=6108
cmp P0, P1
cmovl S1, P1
cmovle P1, P0
cmovge S1, P0
cmp P3, P2
mov S0, P2
cmovg S0, P3
cmovg P3, P2
mov P0, S0
cmp S0, S1
cmovg S0, S1
cmovge S1, P0
cmp P1, P3
cmovle S2, P1
