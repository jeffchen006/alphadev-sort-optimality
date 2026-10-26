# n=5 model=out iset=I1 prefix14_class=5377
mov S2, P0
cmp P2, S2
mov S0, P1
cmovl S2, P2
cmovle P2, P0
cmp S0, P3
cmovge S0, P3
cmovle P1, P3
mov P3, S2
cmp S0, P3
cmovle P3, S0
cmovg S2, S0
cmp P2, P1
cmovg S0, P2
