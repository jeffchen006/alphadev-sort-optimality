# n=5 model=out iset=I1 prefix14_class=387
cmp P2, P3
mov S1, P2
cmovl P2, P3
mov S2, P1
cmovle P3, S1
cmp P1, P0
cmovg P1, P0
cmovg P0, S2
cmovle S2, P0
mov S0, P1
cmp S0, P3
cmovle S0, P3
cmovge P1, P3
cmp P2, P0
