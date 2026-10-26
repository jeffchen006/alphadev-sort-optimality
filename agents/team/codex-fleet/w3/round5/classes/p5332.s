# n=5 model=out iset=I1 prefix14_class=5332
mov S1, P2
cmp P3, P2
cmovl S1, P3
cmovge P2, P3
cmp P0, P1
mov S2, P1
cmovg S2, P0
cmovg P0, P1
cmp P0, S1
mov P1, P0
cmovle P1, S1
cmovle S1, P0
cmp P2, S2
cmovge P0, S2
