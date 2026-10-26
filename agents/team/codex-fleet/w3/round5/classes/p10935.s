# n=5 model=out iset=I1 prefix14_class=10935
cmp P1, P2
cmovle S1, P1
cmovge S1, P2
cmovl P1, P2
cmp P3, P0
cmovge S2, P3
cmovge P3, P0
mov S0, P1
cmovg P0, S2
cmp P0, S0
cmovg S0, P0
cmovle P1, P0
cmp S1, P3
cmovle P0, P3
