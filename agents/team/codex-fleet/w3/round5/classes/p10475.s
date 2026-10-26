# n=5 model=out iset=I1 prefix14_class=10475
mov S0, P1
mov S2, P3
cmp P0, P1
cmovle P1, P0
cmovl P0, S0
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
cmp P0, P2
cmovl S0, P2
cmovle P2, P0
cmovl P0, S0
cmp S2, P1
mov P3, P1
