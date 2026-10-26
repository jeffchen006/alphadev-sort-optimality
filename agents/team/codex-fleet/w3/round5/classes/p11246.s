# n=5 model=out iset=I1 prefix14_class=11246
cmp P3, P1
mov S1, P3
mov S2, P0
cmovl S1, P1
cmovge P3, P1
cmp S2, P2
cmovge S2, P2
cmovle P0, P2
cmp P0, S1
cmovg S0, S1
cmovg S1, P0
mov S1, P3
cmovg P0, S0
cmp S1, S2
