# n=5 model=out iset=I1 prefix14_class=2122
mov S2, P0
cmp P3, P1
cmovle S1, P3
cmovge S1, P1
cmovge P1, P3
cmp S2, P2
cmovge S2, P2
cmovl P0, P2
mov S0, P0
cmp P0, P1
cmovle P0, P1
cmovl P1, S0
mov S0, P1
mov P0, S1
