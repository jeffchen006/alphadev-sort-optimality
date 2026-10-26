# n=5 model=out iset=I1 prefix14_class=5127
mov S0, P3
cmp S0, P0
cmovle P3, P0
mov S2, P2
cmovl P0, S0
cmp P1, S2
cmovl S2, P1
cmovl P1, P2
cmp S2, P0
mov S1, P0
cmovl S1, S2
cmovge P0, S2
mov S1, P1
cmp P3, S1
