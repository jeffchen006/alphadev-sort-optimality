# n=5 model=out iset=I1 prefix14_class=6295
cmp P2, P0
cmovle S1, P0
cmovl P0, P2
cmovge S1, P2
mov S0, P3
cmovle P2, S1
cmp S0, P1
cmovge P3, P1
cmovg P1, S0
cmp P1, S1
cmovle P2, P1
cmovge S1, P1
cmp P0, P3
cmovge S2, P3
