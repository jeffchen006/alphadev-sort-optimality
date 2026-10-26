# n=5 model=out iset=I1 prefix14_class=5328
mov S2, P1
mov S1, P2
cmp P0, P2
cmovge P2, P0
cmovl S1, P0
cmp P1, P3
cmovge S2, P3
cmovle P1, P3
cmp S1, S2
cmovl P0, S2
cmovl S2, S1
cmovge P0, S1
cmp P2, P1
cmovge S1, P2
