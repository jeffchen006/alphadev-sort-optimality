# n=5 model=out iset=I1 prefix14_class=4583
mov S1, P0
mov S0, P3
cmp S0, P1
cmovl P3, P1
cmovl P1, S0
mov S0, P3
cmp S1, P2
cmovg P0, P2
cmovl S1, P2
cmp S1, P3
cmovle S0, S1
cmovle S1, P3
cmp P0, P1
cmovle P3, S0
