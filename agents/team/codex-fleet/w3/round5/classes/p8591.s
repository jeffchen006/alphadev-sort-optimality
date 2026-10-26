# n=5 model=out iset=I1 prefix14_class=8591
mov S1, P1
cmp P2, P0
cmovge S2, P0
cmovl S2, P2
cmovle P2, P0
cmp P1, P3
cmovg P1, P3
cmovge P3, S1
cmp P3, P2
mov P0, P3
cmovle P3, P2
cmovl P2, P0
cmp S2, P1
cmovge S1, S2
