# n=5 model=out iset=I1 prefix14_class=7569
cmp P0, P2
cmovl S2, P0
cmovge S2, P2
mov S1, P3
cmovge P2, P0
cmp P3, P1
cmovle S1, P1
cmovge P3, P1
cmp P3, S2
cmovl P0, P3
cmovl P3, S2
cmovl S2, P0
cmp S1, P2
cmovle P0, S1
