# n=5 model=out iset=I1 prefix14_class=8535
cmp P0, P3
cmovge S1, P0
cmovl S1, P3
cmovle P3, P0
cmp P1, P2
cmovle P0, P2
cmovge P0, P1
cmovle P2, P1
cmp S1, P0
cmovge S0, P0
mov S2, P2
cmovge P0, S1
cmovg S1, S0
cmp P3, P2
