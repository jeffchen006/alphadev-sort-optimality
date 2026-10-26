# n=5 model=out iset=I1 prefix14_class=6819
cmp P1, P2
mov S0, P2
cmovl S0, P1
cmovle P1, P2
mov P2, P0
cmp P3, P2
cmovl P0, P3
cmovge P2, P3
cmp P2, P1
cmovge S1, P1
cmovge P1, P2
mov P3, P0
cmovge P2, S1
cmp S0, P0
