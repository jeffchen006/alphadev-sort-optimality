# n=5 model=out iset=I1 prefix14_class=12238
mov S0, P0
mov S2, P1
cmp S0, P3
cmovge S0, P3
cmovle P0, P3
cmp P2, P1
cmovle P1, P2
cmovg S2, P2
cmp P1, S0
cmovle S1, P1
cmovl P1, S0
cmovle S0, S1
mov P2, P1
cmp P0, S2
