# n=5 model=out iset=I1 prefix14_class=5660
cmp P0, P3
cmovle S1, P3
cmovle P3, P0
cmovle P0, S1
cmp P2, P1
cmovle S2, P2
cmovge S2, P1
cmovle P2, P1
mov S1, P3
cmp S2, P3
cmovl S1, S2
cmovle S2, P3
cmp P0, P2
cmovle S1, P0
