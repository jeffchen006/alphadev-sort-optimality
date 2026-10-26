# n=5 model=out iset=I1 prefix14_class=14131
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
mov S2, P2
cmovl P3, S0
cmp P2, P1
cmovle S2, P1
cmovg P2, P1
cmp S2, P0
cmovle S1, P0
cmovge S1, S2
cmovl P0, S2
mov S2, P0
cmp P2, P3
