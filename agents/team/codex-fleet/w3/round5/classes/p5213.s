# n=5 model=out iset=I1 prefix14_class=5213
mov S1, P0
cmp P0, P3
cmovg S1, P3
cmovle P0, P3
cmp P2, P1
cmovl S0, P2
cmovge S0, P1
mov S2, S1
cmovle P2, P1
cmp S1, S0
cmovge S1, S0
cmovg S0, S2
cmp P2, P0
cmovge P3, P0
