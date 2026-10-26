# n=5 model=out iset=I1 prefix14_class=2136
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovl P0, S0
mov S1, P1
mov S2, P0
cmp P1, P2
cmovg S1, P2
cmovl P1, P2
cmp S2, P1
cmovle S2, P1
cmovle P1, P0
mov P0, P3
cmp P0, S1
