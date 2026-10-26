# n=5 model=out iset=I1 prefix14_class=678
cmp P3, P1
cmovl S0, P1
mov S1, P2
cmovle P1, P3
cmovl P3, S0
cmovge S0, P3
cmp S1, P0
cmovg S1, P0
cmovl P2, P0
cmp P3, P2
cmovl S0, P2
cmovle P2, P3
cmp S1, P1
cmovge P3, S1
