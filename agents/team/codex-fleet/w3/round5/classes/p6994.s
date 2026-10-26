# n=5 model=out iset=I1 prefix14_class=6994
cmp P1, P3
cmovg S1, P3
cmovge P3, P1
cmovle S1, P1
cmp P0, P2
cmovge S0, P2
mov S2, S1
cmovl S0, P0
cmovle P0, P2
cmp S0, S2
cmovl S2, S0
cmovge S1, S0
cmp P3, P0
cmovge P1, P3
