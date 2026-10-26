# n=5 model=out iset=I1 prefix14_class=4296
mov S0, P1
cmp S0, P3
cmovle S0, P3
cmovge P1, P3
cmp P2, P0
cmovle S1, P2
cmovl P2, P0
cmovge S1, P0
mov S2, S1
cmp S2, P1
cmovle S2, P1
cmovl P1, S1
cmp S0, P2
cmovle P0, P2
