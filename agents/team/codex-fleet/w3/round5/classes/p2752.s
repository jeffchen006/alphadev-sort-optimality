# n=5 model=out iset=I1 prefix14_class=2752
mov S1, P1
cmp P1, P3
cmovl S1, P3
cmovge P1, P3
mov P3, P0
cmp P3, P2
cmovle P0, P2
cmovg P3, P2
mov S2, S1
cmp P0, S2
cmovle S1, P0
cmovle P0, S2
cmp P3, P1
cmovge P2, P1
