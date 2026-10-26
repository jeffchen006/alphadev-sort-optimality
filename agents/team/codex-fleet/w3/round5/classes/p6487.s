# n=5 model=out iset=I1 prefix14_class=6487
mov S0, P3
mov S2, P0
cmp P0, P2
cmovl S2, P2
cmovl P2, P0
cmp P1, P3
cmovl P3, P1
cmovg S0, P1
cmp S2, S0
mov S1, S0
cmovle S1, S2
cmovl S2, S0
cmp P3, P2
cmovle P0, P3
