# n=5 model=out iset=I1 prefix14_class=4022
cmp P3, P1
cmovg S0, P1
cmovle S0, P3
cmovle P3, P1
mov S2, P2
cmp P0, P2
cmovl P2, P0
cmovg S2, P0
cmovg P0, P2
cmp S0, P2
cmovle P2, S0
cmovl S0, P0
cmp S2, P3
cmovl S1, S2
