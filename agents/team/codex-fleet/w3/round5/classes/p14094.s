# n=5 model=out iset=I1 prefix14_class=14094
mov S1, P0
cmp P0, P1
cmovle P0, P1
cmovl P1, S1
mov S1, P2
cmp P3, S1
cmovl S1, P3
cmovge P2, P3
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
mov P3, P1
cmp S1, P3
