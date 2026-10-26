# n=5 model=out iset=I1 prefix14_class=2135
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovl P0, S0
mov S2, P1
mov S1, P0
cmp P1, P2
cmovg S2, P2
cmovl P1, P2
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
mov P0, S2
cmp P0, P3
