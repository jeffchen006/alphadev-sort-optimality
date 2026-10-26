# n=5 model=out iset=I1 prefix14_class=11644
cmp P2, P1
cmovg S2, P2
cmovg P2, P1
cmovle S2, P1
mov P1, S2
cmp P3, P0
cmovge S1, P3
cmovg P3, P0
cmovge P0, S1
cmp P1, P0
cmovle S2, P0
cmovge P1, P0
cmp P2, P3
cmovl P0, P1
