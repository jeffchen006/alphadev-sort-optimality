# n=5 model=out iset=I1 prefix14_class=2738
mov S1, P3
cmp S1, P0
mov S2, P1
cmovge S1, P0
cmovg P0, P3
cmp P2, P1
cmovle P1, P2
cmovl P2, S2
cmp P2, P0
cmovle S0, P2
mov P3, P1
cmovl P2, P0
cmovle P0, S0
cmp P1, S1
