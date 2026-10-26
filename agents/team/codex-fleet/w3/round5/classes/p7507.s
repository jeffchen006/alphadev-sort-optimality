# n=5 model=out iset=I1 prefix14_class=7507
mov S2, P3
cmp S2, P1
cmovle S2, P1
cmovl P1, P3
cmp P0, P2
mov S1, P0
cmovle P0, P2
cmovg S1, P2
mov P3, P1
cmp P1, S1
cmovle P3, S1
cmovle S1, P1
cmp S2, P0
cmovle S0, S2
