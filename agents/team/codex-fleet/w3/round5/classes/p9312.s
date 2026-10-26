# n=5 model=out iset=I1 prefix14_class=9312
cmp P0, P3
mov S0, P1
cmovg S2, P0
cmovle S2, P3
cmovle P3, P0
cmp P2, S0
cmovl S0, P2
mov S1, S0
cmovle P2, P1
cmp P3, S0
cmovge S0, P3
cmovl S1, P3
cmp S2, P2
cmovg S1, S2
