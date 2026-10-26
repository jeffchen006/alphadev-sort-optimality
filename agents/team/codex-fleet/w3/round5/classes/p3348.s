# n=5 model=out iset=I1 prefix14_class=3348
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
cmovg S2, P1
cmp P0, P2
cmovge S0, P2
cmovl S0, P0
mov S1, P3
cmovge P2, P0
cmp S1, S0
cmovg P3, S0
cmovg S0, S1
cmp S2, P2
cmovle P1, P2
