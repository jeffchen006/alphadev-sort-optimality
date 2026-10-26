# n=5 model=out iset=I1 prefix14_class=5418
cmp P2, P0
cmovg S1, P0
cmovge P0, P2
cmovg P2, S1
cmp P1, P3
mov S2, P1
cmovl P1, P3
cmovle P3, S2
cmp P3, P2
mov S2, P3
cmovg P3, P2
cmovg P2, S2
cmp P1, P0
cmovle S2, P0
