# n=5 model=out iset=I1 prefix14_class=8701
mov S1, P1
cmp S1, P2
cmovge S1, P2
cmovl P1, P2
mov S0, S1
cmp P0, P3
cmovle P2, P3
mov S2, P1
cmovl P3, P0
cmovle P0, P2
cmp P0, P1
cmovge P1, P0
cmovle S2, P0
cmp S0, P3
