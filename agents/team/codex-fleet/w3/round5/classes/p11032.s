# n=5 model=out iset=I1 prefix14_class=11032
cmp P0, P2
cmovle S2, P0
mov S1, P3
cmovle P0, P2
cmovl P2, S2
cmp S1, P1
mov S0, P0
cmovle S1, P1
cmovl P1, P3
cmp S1, P0
cmovle P0, S1
cmovge S0, S1
mov S0, P1
cmp P2, S0
