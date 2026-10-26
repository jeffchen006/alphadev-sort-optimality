# n=5 model=out iset=I1 prefix14_class=13243
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P0, P3
cmovg S1, P0
cmovg P0, P3
cmovle S1, P3
cmp P0, P1
cmovl S0, P1
cmovl P1, P0
mov S2, S1
cmovl P0, S0
cmp S2, P2
