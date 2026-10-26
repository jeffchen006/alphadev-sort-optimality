# n=5 model=out iset=I1 prefix14_class=2177
cmp P0, P1
cmovge S1, P0
cmovl S1, P1
cmovg P0, P1
cmp P3, P2
cmovle P1, P2
mov S2, S1
cmovle P2, P3
cmovle P3, P1
cmp P3, S2
cmovge S2, P3
cmovl S1, P3
cmp P2, P0
cmovge P3, P0
