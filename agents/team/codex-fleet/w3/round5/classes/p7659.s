# n=5 model=out iset=I1 prefix14_class=7659
cmp P1, P0
cmovle S1, P0
cmovle P0, P1
mov S0, P2
cmovle P1, S1
cmp S0, P3
cmovl S0, P3
cmovge P2, P3
cmovl P3, P2
cmp P2, P0
mov S2, S0
cmovle P2, P0
cmovle P0, P3
mov P3, P2
