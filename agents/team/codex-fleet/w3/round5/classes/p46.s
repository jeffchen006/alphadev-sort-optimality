# n=5 model=out iset=I1 prefix14_class=46
mov S0, P2
mov S1, P1
cmp P3, S0
cmovle P2, P3
cmovl P3, S0
cmp P0, S1
cmovge P1, P0
mov S0, P2
cmovl S1, P0
cmp S0, S1
mov S2, P3
cmovge S0, S1
cmovl P2, S1
cmp P3, P1
