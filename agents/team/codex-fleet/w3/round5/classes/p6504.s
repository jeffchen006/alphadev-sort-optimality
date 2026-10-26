# n=5 model=out iset=I1 prefix14_class=6504
cmp P0, P1
cmovle S1, P1
cmovl P1, P0
mov S2, P3
cmovge S1, P0
cmp P2, S2
cmovl P3, P2
cmovg S2, P2
cmp S1, S2
mov P0, S2
cmovle S2, S1
cmovle S1, P0
mov S1, P3
cmp P1, P3
