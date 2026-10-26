# n=5 model=out iset=I1 prefix14_class=11623
mov S2, P2
cmp P0, P2
cmovg S2, P0
mov S0, P3
cmovge P0, P2
cmp S0, P1
cmovle S0, P1
cmovle P1, P3
cmp S0, S2
cmovge S1, S2
cmovge S2, S0
cmovge S0, S1
cmp P1, P0
cmovl S2, P1
