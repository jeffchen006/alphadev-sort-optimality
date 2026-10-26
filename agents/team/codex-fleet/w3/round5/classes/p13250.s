# n=5 model=out iset=I1 prefix14_class=13250
mov S1, P1
cmp P0, S1
cmovl S1, P0
mov S0, P3
cmovl P0, P1
cmp S0, P2
cmovl P3, P2
cmovle P2, S0
cmp S1, P2
cmovl S0, P2
cmovle P2, S1
cmovl S1, S0
mov P2, P3
cmp P3, P0
