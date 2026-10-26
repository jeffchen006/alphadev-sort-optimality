# n=5 model=out iset=I1 prefix14_class=7848
mov S2, P0
cmp S2, P2
cmovge S2, P2
cmovle P0, P2
mov P2, S2
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
cmp P1, P2
cmovge P2, P1
cmovle S2, P1
cmp P3, P0
cmovl S2, P0
