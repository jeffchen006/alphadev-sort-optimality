# n=5 model=out iset=I1 prefix14_class=6071
cmp P3, P0
cmovle S2, P0
cmovle P0, P3
cmovg S2, P3
mov S0, P1
cmp P1, P2
cmovl P1, P2
cmovl P2, S0
mov S1, P1
cmp S2, S1
cmovg S1, S2
cmovle P1, S2
cmp P0, P2
cmovl S1, P2
