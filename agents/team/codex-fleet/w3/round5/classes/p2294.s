# n=5 model=out iset=I1 prefix14_class=2294
cmp P2, P0
cmovle S2, P0
mov S1, P3
cmovge S2, P2
cmovge P2, P0
cmp P3, P1
cmovle S1, P1
cmovge P3, P1
cmp S1, S2
cmovle P0, S2
cmovl S2, S1
cmovg P0, S1
cmp P3, P2
cmovle P0, P3
