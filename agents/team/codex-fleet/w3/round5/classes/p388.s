# n=5 model=out iset=I1 prefix14_class=388
cmp P2, P3
mov S1, P2
mov S2, P1
cmovl P2, P3
cmovle P3, S1
cmp S2, P0
cmovge P1, P0
cmovge P0, S2
mov S2, P0
mov S0, P1
cmp S0, P3
cmovl S0, P3
cmovge P1, P3
mov S1, S0
