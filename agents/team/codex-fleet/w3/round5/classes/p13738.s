# n=5 model=out iset=I1 prefix14_class=13738
cmp P2, P3
cmovle S1, P3
cmovl P3, P2
mov S2, P1
cmovle P2, S1
cmp S2, P0
cmovge P1, P0
cmovl S2, P0
cmp S2, P2
cmovl P0, P2
cmovge P0, S2
cmovge S2, P2
mov P2, P1
cmp P2, P3
