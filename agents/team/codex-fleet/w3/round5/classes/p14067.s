# n=5 model=out iset=I1 prefix14_class=14067
cmp P0, P2
mov S2, P3
cmovle S0, P0
cmovle P0, P2
cmovl P2, S0
mov S1, P0
cmp P1, S2
cmovle S2, P1
cmovle P1, P3
cmp P0, P1
cmovge S1, P1
cmovle P0, P1
cmp S2, P2
cmovle S0, P2
