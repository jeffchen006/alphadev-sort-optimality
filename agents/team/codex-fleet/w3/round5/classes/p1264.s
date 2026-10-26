# n=5 model=out iset=I1 prefix14_class=1264
cmp P3, P0
cmovg S2, P3
cmovle S2, P0
cmovge P3, P0
mov P0, P2
cmp P2, P1
cmovl P0, P1
mov S1, S2
cmovl P1, P2
cmp S1, P0
cmovl S2, P0
cmovge S1, P0
cmp P3, P1
cmovle P0, S1
