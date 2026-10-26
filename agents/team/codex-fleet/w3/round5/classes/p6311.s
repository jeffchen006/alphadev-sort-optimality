# n=5 model=out iset=I1 prefix14_class=6311
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmovle S2, P3
mov P3, P0
cmp P2, P3
cmovge P3, P2
cmovl P0, P2
cmp P3, P1
cmovge S1, P1
cmovg P1, P3
cmovge P3, S1
cmp P0, S2
cmovg P1, S2
