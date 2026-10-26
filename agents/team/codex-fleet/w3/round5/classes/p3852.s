# n=5 model=out iset=I1 prefix14_class=3852
mov S0, P3
cmp S0, P2
cmovge P3, P2
cmovge P2, S0
cmp P1, P0
cmovge S1, P1
cmovle S1, P0
cmovl P0, P1
cmp P3, P0
cmovle S0, P3
cmovle P3, P0
cmovl P0, S0
cmp S1, P2
cmovge P0, P2
