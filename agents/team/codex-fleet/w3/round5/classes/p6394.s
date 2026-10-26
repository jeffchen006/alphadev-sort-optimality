# n=5 model=out iset=I1 prefix14_class=6394
cmp P3, P1
cmovg S2, P3
cmovge P3, P1
cmovg P1, S2
mov S2, P2
cmp P0, S2
cmovge S2, P0
cmovl P2, P0
cmovl P0, S2
cmp P1, P0
cmovg S2, P1
cmovle P0, P1
cmp P2, P3
cmovle S2, P2
