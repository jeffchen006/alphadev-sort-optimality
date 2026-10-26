# n=5 model=out iset=I1 prefix14_class=6362
cmp P0, P1
mov S1, P0
cmovg P0, P1
mov S2, P2
cmovge P1, S1
cmp P3, P2
cmovl S2, P3
cmovg P2, P3
cmp P2, P1
cmovg S1, P1
cmovle S1, P2
cmovge P1, P2
cmp P0, S2
cmovle P3, S2
