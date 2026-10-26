# n=5 model=out iset=I1 prefix14_class=9364
mov S2, P0
cmp S2, P3
cmovl P0, P3
cmovl P3, S2
cmp P1, P2
cmovl S0, P2
cmovl P2, P1
mov S1, P3
cmovl P1, S0
cmp P2, S1
cmovge P3, P2
cmovge P2, S1
mov P2, P0
mov S1, P3
