# n=5 model=out iset=I1 prefix14_class=3645
mov S2, P0
cmp S2, P1
cmovle P0, P1
cmovl P1, S2
cmp P3, P2
cmovle S0, P2
mov S1, P1
cmovle P2, P3
cmovl P3, S0
cmp P2, P1
cmovge S1, P2
cmovl P1, P2
mov P2, P0
cmp P0, P3
