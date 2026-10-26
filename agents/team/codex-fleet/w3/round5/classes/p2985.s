# n=5 model=out iset=I1 prefix14_class=2985
cmp P2, P0
cmovle S1, P0
cmovg S1, P2
cmovl P0, P2
cmp P1, P3
cmovge S2, P1
cmovge P1, P3
cmovge P3, S2
cmp S1, P3
mov P2, S1
cmovge P2, P3
cmovge P3, S1
cmp P0, P1
cmovge S2, P0
