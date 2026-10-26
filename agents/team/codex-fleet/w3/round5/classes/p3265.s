# n=5 model=out iset=I1 prefix14_class=3265
cmp P2, P1
mov S2, P1
cmovg P1, P2
cmovg P2, S2
cmovl S2, P2
mov S1, P0
cmp P3, P0
cmovge P0, P3
cmovge P3, S1
cmp S2, P3
cmovl P2, P3
cmovge S2, P3
cmp P1, P0
mov S2, P2
