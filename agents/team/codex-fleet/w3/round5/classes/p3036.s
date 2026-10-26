# n=5 model=out iset=I1 prefix14_class=3036
mov S2, P2
cmp P0, P2
cmovle S2, P0
mov S1, P1
cmovle P0, P2
cmp P3, S1
cmovle S1, P3
cmovge P1, P3
mov P3, S2
cmp P3, S1
cmovl S2, S1
cmovl S1, P3
cmp P1, P0
mov S1, P0
