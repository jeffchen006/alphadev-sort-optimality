# n=5 model=out iset=I1 prefix14_class=7379
mov S2, P2
cmp P2, P0
cmovl P2, P0
mov S1, P1
cmovle P0, S2
cmp P3, P1
cmovle S1, P3
cmovg P1, P3
mov S2, P0
cmp S2, S1
cmovge P0, S1
cmovl S2, S1
cmp P2, P1
cmovle S1, P1
