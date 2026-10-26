# n=5 model=out iset=I1 prefix14_class=4366
cmp P1, P2
mov S0, P0
mov S1, P1
cmovg S1, P2
cmovl P1, P2
cmp P3, S0
cmovle S0, P3
cmovl P3, P0
cmp S0, S1
mov P2, P1
cmovle P0, S0
cmovl S0, S1
cmovl S1, P0
cmp P1, P3
