# n=5 model=out iset=I1 prefix14_class=11176
mov S2, P1
cmp P2, P1
cmovg P1, P2
cmovge P2, S2
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
mov S2, P1
cmovle P0, S1
cmp S2, P3
cmovge P1, P3
cmovl S2, P3
cmp P2, P0
cmovle S2, P2
