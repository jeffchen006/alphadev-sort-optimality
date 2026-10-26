# n=5 model=out iset=I1 prefix14_class=7461
mov S0, P0
cmp P3, P0
cmovg S0, P3
mov S2, P1
cmovl P0, P3
cmp P2, S2
cmovle P1, P2
cmovl P2, S2
mov P3, S0
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovl P1, S1
cmp P3, P2
