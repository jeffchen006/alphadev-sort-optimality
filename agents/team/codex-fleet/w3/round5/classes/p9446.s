# n=5 model=out iset=I1 prefix14_class=9446
mov S2, P0
cmp P0, P1
cmovge P0, P1
mov S1, P2
cmovl S2, P1
cmp S1, P3
cmovl S1, P3
cmovge P2, P3
cmp P0, P2
cmovle P3, P2
cmovl P2, P0
cmovl P0, P3
mov S0, S2
cmp S0, S1
