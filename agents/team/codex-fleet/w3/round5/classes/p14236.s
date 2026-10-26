# n=5 model=out iset=I1 prefix14_class=14236
cmp P1, P3
cmovge S1, P1
mov S2, P2
cmovge P1, P3
cmovge P3, S1
cmp S2, P0
mov S0, P3
cmovl S2, P0
cmovle P0, P2
cmp P3, S2
cmovg S0, S2
cmovg S2, P3
cmp P0, P1
mov S2, P0
