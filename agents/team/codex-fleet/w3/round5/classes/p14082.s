# n=5 model=out iset=I1 prefix14_class=14082
mov S0, P3
cmp P3, P0
cmovle P3, P0
cmovle P0, S0
cmp P2, P1
mov S2, P1
cmovg S2, P2
cmovl P1, P2
cmp S2, P3
cmovle P2, P3
mov S1, P1
cmovle P3, S2
cmovle S2, P2
cmp P0, S1
