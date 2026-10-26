# n=5 model=out iset=I1 prefix14_class=12385
mov S0, P0
cmp S0, P2
cmovg S0, P2
cmovle P0, P2
cmp P3, P1
cmovle P2, P1
cmovle P1, P3
cmovle P3, P2
cmp P1, S0
mov S2, S0
cmovl S0, P1
cmovge S2, P1
cmp P0, P3
cmovle S1, P3
