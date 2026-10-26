# n=5 model=out iset=I1 prefix14_class=7578
cmp P1, P0
mov S1, P3
cmovge S2, P0
cmovl S2, P1
cmovg P0, P1
cmovle P1, P0
cmp S1, P2
cmovge S1, P2
cmovle P3, P2
cmp S1, S2
cmovle P2, S1
cmovle S1, S2
cmovl S2, P2
cmp P1, P3
