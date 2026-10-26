# n=5 model=out iset=I1 prefix14_class=8481
mov S0, P2
mov S1, P1
cmp S0, P0
cmovg P2, P0
cmovl S0, P0
cmp S1, P3
cmovl P1, P3
cmovl P3, S1
cmp S0, P1
cmovle S2, P1
cmovle P1, S0
mov P0, P2
cmovl S0, S2
cmp P2, P3
