# n=5 model=out iset=I1 prefix14_class=11342
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovle P0, S0
mov S2, P2
cmp P2, P1
cmovg S2, P1
mov S1, P3
cmovle P2, P1
mov P1, P0
cmp P1, P2
cmovle P0, P2
cmovl P2, P1
cmp S2, P3
