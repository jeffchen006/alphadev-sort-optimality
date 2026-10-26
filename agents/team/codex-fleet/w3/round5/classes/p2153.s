# n=5 model=out iset=I1 prefix14_class=2153
mov S1, P3
cmp S1, P2
cmovle P3, P2
cmovg S1, P2
cmp P0, P1
mov P2, P1
cmovl P1, P0
cmovl P0, P2
cmp P0, P3
cmovl S2, P0
cmovge S2, P3
cmovge P3, P0
cmp P1, S1
cmovle P0, P1
