# n=5 model=out iset=I1 prefix14_class=5517
cmp P2, P1
cmovle S0, P2
mov S2, P0
cmovle P2, P1
cmovl P1, S0
cmp S2, P3
cmovle P0, P3
cmovge S2, P3
cmp S2, P1
mov P3, P0
cmovg S1, S2
cmovle S1, P1
cmovge S2, P1
cmp P2, P0
