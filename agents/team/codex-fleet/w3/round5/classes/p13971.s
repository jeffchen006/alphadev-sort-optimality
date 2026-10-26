# n=5 model=out iset=I1 prefix14_class=13971
cmp P3, P0
mov S0, P1
cmovle S1, P3
cmovg S1, P0
cmovle P3, P0
cmp P2, S0
cmovg S0, P2
cmovl P1, P2
cmp P3, S0
cmovle S2, S0
cmovl S0, P3
cmovl P3, S2
cmp S1, P1
mov P0, S0
