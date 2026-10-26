# n=5 model=out iset=I1 prefix14_class=9370
mov S0, P0
cmp S0, P3
cmovle P0, P3
cmovl P3, S0
cmp P2, P1
cmovl S0, P1
mov S2, P3
cmovl P1, P2
cmovl P2, S0
cmp P1, S2
cmovge P3, P1
cmovge P1, S2
cmp P0, P2
mov P1, P2
