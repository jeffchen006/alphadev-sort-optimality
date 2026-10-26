# n=5 model=out iset=I1 prefix14_class=4642
mov S1, P0
cmp P3, S1
cmovg S1, P3
cmovl P0, P3
mov S0, P2
cmp P1, S0
cmovl S0, P1
cmovl P1, P2
cmp P1, S1
cmovle S2, P1
cmovg S2, S1
cmovle P1, S1
cmp P0, S0
mov P1, S0
