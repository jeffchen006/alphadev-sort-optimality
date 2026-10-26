# n=5 model=out iset=I1 prefix14_class=11015
cmp P2, P1
cmovge S0, P2
cmovg P2, P1
cmovl S0, P1
mov S1, P0
cmp P3, S1
cmovle P0, P3
cmovg S1, P3
cmp S1, S0
cmovl P1, S1
cmovl S1, S0
cmovl S0, P1
cmp P2, P0
cmovle P1, P0
