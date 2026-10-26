# n=5 model=out iset=I1 prefix14_class=2766
cmp P0, P2
cmovle S2, P2
cmovge S2, P0
cmovge P0, P2
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
cmovge S0, P1
cmp S2, P3
cmovle P1, P3
cmovle P3, S2
cmovle S2, P1
cmp S0, P0
mov S2, S0
