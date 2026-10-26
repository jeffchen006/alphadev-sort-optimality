# n=5 model=out iset=I1 prefix14_class=9340
mov S1, P0
cmp P1, S1
cmovle P0, P1
cmovge S1, P1
mov S2, P3
cmp P2, S2
cmovl S2, P2
cmovle P2, P3
cmp S2, P0
cmovge S0, S2
cmovl S0, P0
cmovg S2, P0
cmp S1, P2
cmovge P3, P2
