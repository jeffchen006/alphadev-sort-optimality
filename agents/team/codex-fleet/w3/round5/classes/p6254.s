# n=5 model=out iset=I1 prefix14_class=6254
mov S1, P3
cmp S1, P2
cmovg S1, P2
cmovle P3, P2
mov S0, P0
cmp P1, S0
cmovl S0, P1
cmovg P0, P1
cmp P0, P3
cmovl S2, P3
cmovle P3, P0
cmovge S2, P0
cmp S1, S0
cmovge P1, S0
