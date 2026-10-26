# n=5 model=out iset=I1 prefix14_class=5663
cmp P3, P2
cmovle S0, P2
cmovl P2, P3
mov S1, P0
cmovle P3, S0
cmp S1, P1
cmovl S1, P1
cmovle P1, P0
cmp P1, P2
mov P0, P2
cmovl P0, P1
cmovl P1, P2
cmp S1, P3
cmovle S0, S1
