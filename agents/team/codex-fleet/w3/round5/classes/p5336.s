# n=5 model=out iset=I1 prefix14_class=5336
mov S0, P3
cmp P0, P1
cmovge S1, P0
cmovle S1, P1
cmovl P1, P0
cmp P2, S0
cmovg S0, P2
cmovg P2, P3
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
cmovg S2, P1
cmp S0, S1
cmovg P1, S1
