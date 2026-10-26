# n=5 model=out iset=I1 prefix14_class=11048
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmovle P2, S1
mov S2, P3
cmp P3, P0
cmovle S2, P0
cmovle P0, P3
cmp S2, P1
mov S0, S2
cmovle S2, P1
cmovg S0, P1
cmp P0, P2
cmovle P1, P0
