# n=5 model=out iset=I1 prefix14_class=6532
cmp P1, P3
cmovg S2, P1
cmovg P1, P3
cmovg P3, S2
cmp P2, P0
cmovle S1, P0
cmovg S1, P2
cmovl P0, P2
cmovl P2, S1
cmp P2, P3
cmovg S1, P3
cmovle P2, P3
cmp P1, P0
cmovge P2, P0
