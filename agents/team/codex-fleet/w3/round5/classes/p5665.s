# n=5 model=out iset=I1 prefix14_class=5665
cmp P3, P2
cmovl S0, P2
cmovle P2, P3
mov S1, P0
mov S2, P2
cmovl P3, S0
cmp S1, P1
cmovle S1, P1
cmovl P1, P0
cmp P1, P2
cmovle S2, P1
cmovle P1, P2
cmp S1, P3
cmovg S2, S1
