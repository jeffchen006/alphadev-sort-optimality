# n=5 model=out iset=I1 prefix14_class=143
mov S1, P1
cmp S1, P3
cmovle P1, P3
cmovge S1, P3
cmp P0, P2
cmovl P3, P2
cmovge P3, P0
cmovle P2, P0
mov S2, P2
cmp S2, S1
cmovl S2, S1
cmovg P2, S1
mov P0, S2
mov P2, P3
