# n=5 model=out iset=I1 prefix14_class=8553
cmp P2, P3
cmovle S1, P2
cmovle P2, P3
cmovl P3, S1
mov S2, P0
cmp P0, P1
cmovle S2, P1
cmovg P0, P1
cmp S2, P2
cmovge S0, S2
cmovg S2, P2
cmovg P2, S0
cmp P0, P3
cmovle S0, P3
