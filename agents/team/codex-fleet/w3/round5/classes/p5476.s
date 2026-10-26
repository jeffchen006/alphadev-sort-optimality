# n=5 model=out iset=I1 prefix14_class=5476
cmp P3, P2
mov S2, P3
cmovle P3, P2
cmovge S2, P2
mov S1, P0
cmp P0, P1
mov P2, S2
cmovg S1, P1
cmovle P0, P1
cmp P2, S1
cmovl S2, S1
cmovg P2, S1
cmp P3, P0
cmovle P1, P0
