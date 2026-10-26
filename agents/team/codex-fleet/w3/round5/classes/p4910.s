# n=5 model=out iset=I1 prefix14_class=4910
cmp P1, P0
mov S2, P3
cmovg S0, P1
cmovle S0, P0
cmovle P0, P1
cmp P2, P3
mov P1, P0
cmovle P3, P2
cmovl P2, S2
cmp P0, P3
cmovg P1, P3
cmovl P0, P3
cmp P2, S0
cmovle S1, S0
