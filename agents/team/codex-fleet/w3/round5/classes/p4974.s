# n=5 model=out iset=I1 prefix14_class=4974
mov S1, P1
cmp P1, P0
cmovge S1, P0
mov S0, P2
mov S2, S1
cmovle P1, P0
cmp S0, P3
cmovle S0, P3
cmovg P2, P3
cmp P2, S1
cmovle S1, P2
cmovge S2, P2
mov S1, P1
cmovl P2, S2
