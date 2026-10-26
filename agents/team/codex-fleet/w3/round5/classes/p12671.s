# n=5 model=out iset=I1 prefix14_class=12671
cmp P0, P3
mov S0, P0
cmovge S0, P3
cmovg P3, P0
mov P0, S0
cmp P2, P1
cmovl S1, P1
cmovle P1, P2
cmovl P2, S1
cmp S0, P1
cmovl P0, P1
cmovg S0, P1
cmp P3, P2
cmovle P1, P3
