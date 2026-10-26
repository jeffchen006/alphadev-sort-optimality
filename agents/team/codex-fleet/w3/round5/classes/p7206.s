# n=5 model=out iset=I1 prefix14_class=7206
mov S0, P3
cmp S0, P2
mov S2, P0
cmovl P3, P2
cmovge S0, P2
cmp P1, S2
cmovge P0, P1
cmovle S2, P1
mov S1, S2
cmp S2, S0
cmovl S2, S0
cmovg S1, S0
cmp P3, P0
cmovle P2, P3
