# n=5 model=out iset=I1 prefix14_class=10992
mov S2, P1
cmp P0, S2
cmovle P1, P0
cmovl P0, S2
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
mov S0, P2
cmovl P3, S2
cmp S0, P0
cmovl S0, P0
cmovl P0, P2
cmp P1, P3
cmovl P2, P3
