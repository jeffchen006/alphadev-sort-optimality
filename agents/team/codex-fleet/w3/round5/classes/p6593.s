# n=5 model=out iset=I1 prefix14_class=6593
mov S2, P2
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
mov P2, P3
cmp P3, P0
cmovle P2, P0
cmovl P0, P3
cmp S2, P2
cmovge S0, S2
cmovge S2, P2
mov S1, P0
cmovge P2, S0
cmp P0, P1
