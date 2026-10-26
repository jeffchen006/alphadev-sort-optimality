# n=5 model=out iset=I1 prefix14_class=3893
mov S0, P2
cmp S0, P1
cmovge P2, P1
cmovge P1, S0
cmp P3, P0
cmovl S0, P3
mov S1, P2
cmovle P3, P0
cmovl P0, S0
cmp P2, P0
cmovle P2, P0
cmovl P0, S1
cmp P1, P3
mov S1, P3
