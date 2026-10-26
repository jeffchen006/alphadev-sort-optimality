# n=5 model=out iset=I1 prefix14_class=3831
mov S2, P1
cmp S2, P3
cmovge S2, P3
cmovge P3, P1
cmp P0, P2
cmovge P1, P0
cmovl P1, P2
cmovle P2, P0
cmp P2, S2
cmovl S1, P2
cmovl P2, S2
cmovl S2, S1
cmp P3, P1
mov S2, P3
