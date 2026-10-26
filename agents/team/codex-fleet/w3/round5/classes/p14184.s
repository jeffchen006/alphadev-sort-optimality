# n=5 model=out iset=I1 prefix14_class=14184
cmp P0, P1
cmovge S0, P0
cmovl S0, P1
mov S1, P2
cmovle P1, P0
cmp S1, P3
cmovg S1, P3
cmovl P2, P3
cmp P2, S0
cmovge P3, P2
cmovg P2, S0
cmovg S0, P3
cmp S1, P1
cmovge S0, P1
