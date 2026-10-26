# n=5 model=out iset=I1 prefix14_class=7299
cmp P1, P3
mov S2, P3
cmovl S2, P1
mov S0, S2
mov S1, P2
cmovle P1, P3
cmp P0, S1
cmovle S1, P0
cmovle P0, P2
cmp S0, S1
cmovg S2, S1
cmovge S1, S0
cmp P0, P1
cmovge S2, P1
