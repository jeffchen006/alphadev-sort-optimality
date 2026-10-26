# n=5 model=out iset=I1 prefix14_class=44
mov S1, P0
mov S0, P3
cmp P2, P3
cmovle P3, P2
cmovle P2, S0
cmp P1, S1
cmovge P0, P1
cmovl S1, P1
mov S0, P3
cmp S0, S1
cmovl P3, S1
cmovge S0, S1
mov S2, P0
cmp S2, P2
