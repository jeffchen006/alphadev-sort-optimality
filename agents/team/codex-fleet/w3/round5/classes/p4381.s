# n=5 model=out iset=I1 prefix14_class=4381
mov S2, P2
mov S1, P3
cmp P0, P2
cmovle P2, P0
cmovl P0, S2
cmovle S2, P2
cmp P1, P3
cmovl P3, P1
cmovge S1, P1
cmp S2, P3
cmovle S2, P3
cmovge P2, P3
mov S0, S2
cmp P0, S1
