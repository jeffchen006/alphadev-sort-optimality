# n=5 model=out iset=I1 prefix14_class=12647
mov S2, P0
cmp P2, S2
cmovl S2, P2
mov S1, P1
cmovge P0, P2
cmp P3, S1
cmovle S1, P3
cmovle P3, P1
cmp S2, S1
cmovle P2, S1
cmovle S1, S2
cmovle S2, P2
cmp P3, P0
cmovle P2, P3
