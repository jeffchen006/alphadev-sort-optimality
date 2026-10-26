# n=5 model=out iset=I1 prefix14_class=11016
cmp P2, P3
cmovg S0, P2
mov S2, P0
cmovge P2, P3
cmovle S0, P3
cmp P1, S2
cmovle P0, P1
cmovge S2, P1
cmp S2, S0
cmovle P3, S2
cmovl S2, S0
cmovl S0, P3
cmp P2, P0
cmovle P3, P0
