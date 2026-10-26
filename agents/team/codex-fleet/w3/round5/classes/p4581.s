# n=5 model=out iset=I1 prefix14_class=4581
mov S0, P0
cmp P2, P1
cmovle S2, P1
cmovge S2, P2
cmovl P1, P2
cmp P3, S0
cmovle S0, P3
cmovle P3, P0
mov S1, S2
cmp P3, S2
cmovle S1, P3
cmovle P3, S2
cmp S0, P1
cmovge P2, S0
