# n=5 model=out iset=I1 prefix14_class=1130
mov S2, P1
cmp P3, P1
mov S1, P2
cmovle P1, P3
cmovge S2, P3
cmp P0, S1
cmovg S1, P0
cmovge P0, P2
cmp S2, S1
cmovl P3, S1
cmovge P3, S2
cmovl S1, S2
cmp P1, P0
cmovl S2, P0
