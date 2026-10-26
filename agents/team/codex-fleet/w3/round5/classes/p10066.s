# n=5 model=out iset=I1 prefix14_class=10066
mov S1, P2
cmp P0, P1
cmovl S2, P0
cmovle P0, P1
cmovl P1, S2
cmp P3, S1
cmovle S1, P3
cmovge P2, P3
mov S0, P0
cmp S0, P2
cmovl P0, P2
cmovge S0, P2
mov P0, S1
cmp P1, P0
