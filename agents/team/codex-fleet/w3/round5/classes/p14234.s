# n=5 model=out iset=I1 prefix14_class=14234
mov S2, P2
cmp P3, P1
cmovge S1, P3
cmovge P3, P1
cmovge P1, S1
cmp S2, P0
mov S0, P1
cmovl S2, P0
cmovle P0, P2
cmp P1, S2
cmovg S0, S2
cmovg S2, P1
cmp P0, P3
cmovle S2, P0
