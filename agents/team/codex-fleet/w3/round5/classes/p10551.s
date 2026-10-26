# n=5 model=out iset=I1 prefix14_class=10551
mov S0, P2
cmp P1, S0
cmovl P2, P1
cmovg S0, P1
cmp P3, P0
cmovge S1, P3
cmovl S1, P0
cmovl P0, P3
cmp S0, S1
cmovle P1, S0
cmovl S0, S1
cmovl S1, P1
cmp P0, P2
cmovge P3, P0
