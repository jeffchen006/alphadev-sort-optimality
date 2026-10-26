# n=5 model=out iset=I1 prefix14_class=14306
mov S1, P0
cmp P2, S1
cmovl S1, P2
cmovg P0, P2
mov S2, P3
cmp S2, P1
cmovle P3, P1
cmovg S2, P1
cmp S2, S1
cmovge P2, S2
cmovge S2, S1
cmovge S1, P2
mov S0, S1
cmp P0, P3
