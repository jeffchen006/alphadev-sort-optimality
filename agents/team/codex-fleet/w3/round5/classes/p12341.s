# n=5 model=out iset=I1 prefix14_class=12341
cmp P1, P0
cmovl S0, P1
cmovge S0, P0
cmovle P1, P0
mov S1, P2
cmp P3, S1
cmovg S1, P3
cmovge P3, P2
cmp S0, P3
cmovge P0, S0
cmovg S0, P3
cmovg P3, P0
mov S2, P1
cmp P1, S1
