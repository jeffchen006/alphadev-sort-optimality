# n=5 model=out iset=I1 prefix14_class=9190
mov S2, P3
cmp P1, S2
cmovge P3, P1
cmovl S2, P1
cmp P2, P0
cmovg P1, P0
cmovle P1, P2
cmovle P2, P0
cmp S2, P1
cmovge S1, S2
cmovge S2, P1
mov P0, P2
cmovg P1, S1
cmp P3, P2
