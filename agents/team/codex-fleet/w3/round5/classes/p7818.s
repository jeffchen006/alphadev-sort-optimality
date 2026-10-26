# n=5 model=out iset=I1 prefix14_class=7818
mov S2, P2
cmp P3, P2
cmovl P2, P3
cmovge S2, P3
cmp P0, P1
mov S1, P0
cmovg S1, P1
cmovge P1, P0
cmp P2, S1
cmovle P3, S1
mov P0, S2
cmovl S1, P2
cmovl P2, P3
cmp S2, P1
