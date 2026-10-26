# n=5 model=out iset=I1 prefix14_class=9099
mov S1, P0
cmp S1, P1
mov S0, P2
cmovge S1, P1
cmovl P0, P1
cmp S0, P3
cmovge P2, P3
cmovl S0, P3
cmp P2, S1
cmovle P3, P2
cmovl P2, S1
cmovl S1, P3
mov S2, P0
cmp S0, P0
