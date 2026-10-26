# n=5 model=out iset=I1 prefix14_class=13569
cmp P2, P1
cmovle S2, P2
cmovle P2, P1
mov S1, P3
cmovl P1, S2
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
mov P3, P1
cmp S1, P3
cmovge P1, S1
cmovge S1, P3
cmp P2, P0
cmovge S0, P0
