# n=5 model=out iset=I1 prefix14_class=691
mov S0, P3
cmp P2, S0
cmovle S0, P2
cmovle P2, P3
mov S2, P0
mov S1, P2
cmp S2, P1
cmovge S2, P1
cmovl P0, P1
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
mov P1, S2
cmp S2, S0
