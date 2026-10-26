# n=5 model=out iset=I1 prefix14_class=232
mov S0, P1
cmp P0, P2
cmovge S2, P0
cmovle S2, P2
cmovle P2, P0
cmp S0, P3
cmovg S0, P3
cmovge P3, P1
cmp S0, P2
mov S1, S0
cmovl S1, P2
cmovle P2, S0
cmovl S0, S1
cmp S2, P3
