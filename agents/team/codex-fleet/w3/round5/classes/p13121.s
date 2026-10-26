# n=5 model=out iset=I1 prefix14_class=13121
mov S0, P2
cmp P3, P2
cmovl P2, P3
cmovle P3, S0
cmp P0, P1
cmovl S2, P0
cmovl P0, P1
cmovl P1, S2
mov S0, P1
cmp S0, P2
cmovle S0, P2
cmovle P2, P1
mov P2, S0
mov P1, P3
