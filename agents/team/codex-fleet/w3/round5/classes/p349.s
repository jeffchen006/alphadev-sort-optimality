# n=5 model=out iset=I1 prefix14_class=349
mov S1, P2
cmp P2, P0
cmovg P2, P0
cmovge P0, S1
mov S1, P3
cmp S1, P1
cmovge S1, P1
cmovge P1, P3
cmp P2, S1
cmovge P3, S1
cmovl P3, P2
mov P3, P0
cmovl P2, S1
cmp P1, P0
