# n=5 model=out iset=I1 prefix14_class=5816
mov S0, P0
mov S2, P1
cmp S2, P3
cmovl P1, P3
cmovle P3, S2
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmp P3, P2
cmovle S1, P3
cmovg S1, P2
cmovle P3, P2
cmp P1, S0
cmovle S1, S0
