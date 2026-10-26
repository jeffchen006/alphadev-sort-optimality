# n=5 model=out iset=I1 prefix14_class=5463
cmp P3, P1
cmovle S2, P3
cmovg S2, P1
cmovl P3, P1
cmp P2, P0
mov S1, S2
cmovg P1, P0
cmovge P0, P2
cmovg P2, P1
cmp P2, S2
cmovle S1, P2
cmovl P2, S2
mov S2, P3
cmp P3, P0
