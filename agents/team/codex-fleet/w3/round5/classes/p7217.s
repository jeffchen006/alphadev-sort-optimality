# n=5 model=out iset=I1 prefix14_class=7217
cmp P3, P2
cmovle S1, P2
cmovg S1, P3
cmovg P3, P2
mov S2, P1
mov S0, P3
cmp P0, P1
cmovge S2, P0
cmovle P1, P0
cmp S0, P1
cmovg S0, P1
cmovl P3, P1
cmp S2, S1
cmovl P0, S2
