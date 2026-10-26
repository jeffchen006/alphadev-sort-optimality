# n=5 model=out iset=I1 prefix14_class=7862
mov S1, P3
cmp P2, P3
cmovge S1, P2
cmovl P3, P2
cmp P0, P1
cmovge P2, P1
cmovle P2, P0
cmovge P1, P0
cmp P2, P3
cmovl S0, P2
cmovle P2, P3
cmovl P3, S0
mov P0, P2
cmp S1, P1
