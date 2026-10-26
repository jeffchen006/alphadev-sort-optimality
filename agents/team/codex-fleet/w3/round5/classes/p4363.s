# n=5 model=out iset=I1 prefix14_class=4363
cmp P1, P2
mov S0, P0
cmovle S1, P1
cmovle P1, P2
cmovg S1, P2
cmp P3, P0
cmovl P0, P3
cmovl P3, S0
cmp P0, S1
mov S2, P0
cmovle P0, S1
cmovl S1, S2
mov P2, P3
mov S1, P0
