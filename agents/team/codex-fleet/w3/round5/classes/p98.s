# n=5 model=out iset=I1 prefix14_class=98
mov S1, P0
cmp P2, S1
mov S2, P3
cmovge P0, P2
cmovge P2, S1
cmp P1, S2
cmovge S2, P1
cmovl P3, P1
cmp P2, P3
cmovl P1, P3
cmovge P1, P2
cmovl P3, P2
cmovl P2, P1
cmp S2, P0
