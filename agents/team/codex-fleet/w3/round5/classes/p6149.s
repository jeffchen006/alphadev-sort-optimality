# n=5 model=out iset=I1 prefix14_class=6149
cmp P1, P2
mov S0, P1
mov S1, P3
cmovle S0, P2
cmovg P1, P2
cmp S1, P0
cmovle P3, P0
cmovge S1, P0
cmp P3, S0
mov P0, P3
cmovg P0, S0
cmovg S0, P3
cmp S1, P1
cmovl S2, S1
