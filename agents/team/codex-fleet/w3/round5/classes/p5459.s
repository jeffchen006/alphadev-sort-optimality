# n=5 model=out iset=I1 prefix14_class=5459
cmp P1, P2
cmovle S2, P1
cmovg S2, P2
cmovle P1, P2
cmp P3, P0
mov S1, S2
cmovge P2, P0
cmovge P0, P3
cmovg P3, P2
cmp P3, S1
cmovl S1, P3
cmovle P3, S2
cmp P1, P0
cmovg S2, P1
