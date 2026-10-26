# n=5 model=out iset=I1 prefix14_class=12973
mov S2, P0
cmp P0, P1
cmovg P0, P1
cmovle S2, P1
cmp P2, P3
cmovl P1, P2
cmovge P1, P3
cmovle P2, P3
cmp P1, P0
cmovge S1, P0
cmovge P0, P1
cmovge P1, S1
cmp P2, S2
cmovge S1, P2
