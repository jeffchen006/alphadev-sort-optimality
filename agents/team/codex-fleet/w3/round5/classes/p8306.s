# n=5 model=out iset=I1 prefix14_class=8306
cmp P1, P0
mov S2, P0
cmovle P0, P1
cmovge S2, P1
cmp P3, P2
mov S0, P3
cmovl S0, P2
cmovge P3, P2
mov S1, P0
cmp P0, P3
cmovle P0, P3
cmovge S1, P3
cmp S2, S0
cmovge P1, S2
