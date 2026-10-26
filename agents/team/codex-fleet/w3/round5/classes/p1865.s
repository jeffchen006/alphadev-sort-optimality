# n=5 model=out iset=I1 prefix14_class=1865
mov S2, P0
cmp P2, P0
mov S1, P3
cmovg P0, P2
cmovle S2, P2
cmp P1, S1
cmovge P3, P1
cmovl S1, P1
cmp P3, P0
cmovle P2, P3
mov P1, S1
cmovle P3, P0
cmovle P0, P2
cmp S1, S2
