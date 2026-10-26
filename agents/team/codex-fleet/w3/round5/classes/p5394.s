# n=5 model=out iset=I1 prefix14_class=5394
cmp P2, P1
cmovle S2, P2
cmovge S2, P1
cmovl P2, P1
cmp P3, P0
mov S1, P3
cmovl S1, P0
cmovge P3, P0
cmp S2, P3
cmovge P1, S2
cmovg S2, P3
mov P0, P2
cmovge P3, P1
cmp S1, P0
