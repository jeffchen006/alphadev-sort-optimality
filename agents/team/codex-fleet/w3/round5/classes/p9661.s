# n=5 model=out iset=I1 prefix14_class=9661
mov S2, P2
mov S1, P0
cmp P2, P3
cmovge S2, P3
cmovle P2, P3
cmp S1, P1
cmovl S1, P1
mov S0, S1
cmovl P1, P0
cmp P2, S1
cmovge S0, P2
cmovge P2, S1
cmp S2, P1
cmovl P3, P1
