# n=5 model=out iset=I1 prefix14_class=1986
mov S2, P3
cmp P1, P0
cmovge S1, P1
cmovle S1, P0
cmovge P1, P0
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
cmovge P3, P2
cmp P3, S1
cmovle P3, S1
cmovl S1, P2
cmp S2, P1
cmovl P0, S2
