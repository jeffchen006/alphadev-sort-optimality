# n=5 model=out iset=I1 prefix14_class=5416
cmp P0, P2
cmovg S1, P2
cmovge P2, P0
cmovg P0, S1
cmp P1, P3
mov S2, P1
cmovl P1, P3
cmovle P3, S2
cmp P3, P0
cmovge S2, P3
cmovg P3, P0
cmovg P0, S2
cmp P1, P2
cmovle S2, P2
