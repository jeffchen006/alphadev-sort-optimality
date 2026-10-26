# n=5 model=out iset=I1 prefix14_class=4603
mov S1, P0
cmp P3, P0
cmovg S1, P3
cmovl P0, P3
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
mov P3, S1
cmovl P1, S2
cmp P1, S1
mov S0, P2
cmovl S1, P1
cmovg P3, P1
cmp P0, S0
