# n=5 model=out iset=I1 prefix14_class=3221
mov S2, P3
mov S1, P0
cmp P2, P3
cmovle S2, P2
cmovg P3, P2
cmp P1, P0
cmovle P0, P1
cmovg S1, P1
cmovg P1, P0
cmp S2, P0
cmovge P1, S2
cmovge S2, P0
cmp S1, P3
cmovl S2, P3
