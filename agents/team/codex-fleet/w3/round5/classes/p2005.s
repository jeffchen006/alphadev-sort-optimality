# n=5 model=out iset=I1 prefix14_class=2005
mov S1, P1
cmp P0, S1
cmovg P1, P0
cmovge P0, S1
mov S1, P3
cmp P3, P2
cmovge S1, P2
cmovl P3, P2
mov P2, P3
cmp P1, P3
cmovge P2, P1
cmovg P1, P3
cmovl P3, P1
cmp S1, P0
