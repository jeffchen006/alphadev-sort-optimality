# n=5 model=out iset=I1 prefix14_class=1304
mov S1, P0
mov S2, P2
cmp P1, P0
cmovle S1, P1
cmovl P1, P0
mov P0, P1
cmp S2, P3
cmovle P2, P3
cmovge S2, P3
cmovl P3, S2
cmp P0, P2
cmovge P1, P2
cmovl P0, P2
mov S0, P1
