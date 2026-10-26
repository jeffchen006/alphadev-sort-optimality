# n=5 model=out iset=I1 prefix14_class=5825
cmp P3, P1
mov S1, P1
cmovge P1, P3
cmovl S1, P3
cmp P0, P2
cmovle P3, P0
cmovl P0, P2
cmovl P2, P3
cmp S1, P2
cmovge S0, S1
cmovl S0, P2
cmovge S1, P2
mov P2, P1
cmp P1, P0
