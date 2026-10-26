# n=5 model=out iset=I1 prefix14_class=9458
cmp P1, P3
mov S2, P1
cmovl P1, P3
cmovl P3, S2
cmp P0, P2
mov S0, P2
cmovl S0, P0
cmovle P0, P2
mov S1, P3
cmp S0, S1
cmovg P3, S0
cmovle S1, S0
mov S1, P0
cmovle S0, P3
