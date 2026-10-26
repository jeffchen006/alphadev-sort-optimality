# n=5 model=out iset=I1 prefix14_class=930
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
cmovg S1, P0
mov S2, P1
cmp S2, P3
cmovg P1, P3
cmovg P3, S2
cmp P3, S1
cmovle S2, S1
cmovge S2, P3
cmovge P3, S1
cmp P1, P2
cmovl S1, P3
