# n=5 model=out iset=I1 prefix14_class=11081
mov S0, P1
mov S1, P3
cmp S1, P0
cmovle S1, P0
cmovle P0, P3
cmp P1, P2
mov S2, S1
cmovl S0, P2
cmovl P2, P1
cmp S0, S1
cmovl S2, S0
cmovl S0, S1
cmp P2, P0
cmovle P3, P2
