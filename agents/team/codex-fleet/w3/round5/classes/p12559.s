# n=5 model=out iset=I1 prefix14_class=12559
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
mov S2, P2
cmp P2, P0
cmovl P2, P0
cmovg S2, P0
cmp S2, P1
mov P0, P2
cmovle S0, P1
cmovl P1, S2
cmovl S2, S0
cmp P2, P3
