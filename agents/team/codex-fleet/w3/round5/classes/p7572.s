# n=5 model=out iset=I1 prefix14_class=7572
cmp P1, P2
mov S0, P2
cmovg P2, P1
cmovl S0, P1
mov S1, P0
cmp S1, P3
cmovl S1, P3
cmovg P0, P3
cmp P0, S0
cmovle P3, P0
cmovle P0, S0
cmovle S0, P3
cmp S1, P2
cmovl P1, S1
