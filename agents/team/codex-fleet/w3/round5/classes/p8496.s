# n=5 model=out iset=I1 prefix14_class=8496
mov S2, P2
cmp P1, S2
cmovl P2, P1
cmovl P1, S2
cmp P3, P0
cmovle S2, P3
mov S0, P1
cmovl P3, P0
cmovl P0, S2
cmp P3, P1
cmovg S0, P3
mov S1, P0
cmovle P1, P3
cmp P2, P0
