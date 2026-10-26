# n=5 model=out iset=I1 prefix14_class=7274
mov S0, P0
cmp P3, P1
cmovl S2, P3
cmovle P3, P1
cmovl P1, S2
cmp P2, S0
cmovle S0, P2
cmovle P2, P0
cmp S0, P1
cmovg P0, P1
cmovle P0, S0
cmovg P1, S0
cmp P2, P3
cmovle P0, P3
