# n=5 model=out iset=I1 prefix14_class=35
mov S2, P0
cmp P3, P0
cmovle P0, P3
cmovl P3, S2
cmp P1, P2
cmovge S0, P2
cmovle S0, P1
mov S1, P0
cmovge P2, P1
cmp S1, S0
cmovle P0, S0
cmovge S1, S0
cmp P3, P2
mov S0, P3
