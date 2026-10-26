# n=5 model=out iset=I1 prefix14_class=5334
mov S0, P3
cmp P2, P1
cmovge S1, P2
cmovle S1, P1
cmovl P1, P2
cmp P0, S0
cmovg S0, P0
cmovg P0, P3
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmovg S2, P0
cmp S0, S1
cmovg P0, S1
