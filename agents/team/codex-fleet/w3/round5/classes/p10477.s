# n=5 model=out iset=I1 prefix14_class=10477
mov S0, P1
cmp P0, P1
cmovle P1, P0
cmovl P0, S0
cmp P3, P2
mov S2, P2
cmovle S2, P3
cmovle P3, P2
cmp P0, P3
cmovl S0, P3
cmovle P3, P0
cmovl P0, S0
mov P0, P3
cmp S2, P1
