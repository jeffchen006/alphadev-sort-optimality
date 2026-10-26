# n=5 model=out iset=I1 prefix14_class=13245
cmp P2, P1
cmovl S1, P1
cmovle P1, P2
cmovl P2, S1
cmp P0, P3
mov S0, P0
cmovg P0, P3
cmovle S0, P3
cmp P1, P0
cmovle P3, P0
cmovl P0, P1
mov S2, S0
cmovl P1, P3
cmp S2, P2
