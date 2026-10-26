# n=5 model=out iset=I1 prefix14_class=11338
cmp P3, P2
cmovle S0, P2
cmovle P2, P3
cmovle P3, S0
cmp P1, P0
cmovl S1, P0
cmovge S1, P1
cmovg P1, P0
cmp S1, P3
cmovle S2, S1
cmovl S1, P3
cmovle P3, S2
mov P0, P1
cmp P2, P1
