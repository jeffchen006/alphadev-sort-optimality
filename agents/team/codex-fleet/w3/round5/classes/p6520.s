# n=5 model=out iset=I1 prefix14_class=6520
mov S0, P2
cmp S0, P1
cmovg P2, P1
cmovg P1, S0
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovle P0, S0
cmp P0, P1
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
mov S1, P2
cmp P3, S1
