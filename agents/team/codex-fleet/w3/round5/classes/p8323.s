# n=5 model=out iset=I1 prefix14_class=8323
cmp P2, P1
cmovl S2, P2
cmovl P2, P1
cmovl P1, S2
cmp P3, P0
cmovle S0, P3
cmovle P3, P0
cmovg S0, P0
mov P0, P1
cmp P1, S0
cmovle P0, S0
cmovle S0, P1
mov S0, P3
cmp P3, P2
