# n=5 model=out iset=I1 prefix14_class=10265
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
cmovle P1, S1
cmp P2, P0
cmovle S2, P2
mov S0, P1
cmovl P2, P0
cmovg S2, P0
cmp P1, P2
cmovl P1, P2
mov P0, P3
cmovl P2, S0
cmp S2, P0
