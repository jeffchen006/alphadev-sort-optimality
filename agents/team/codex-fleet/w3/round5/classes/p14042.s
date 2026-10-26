# n=5 model=out iset=I1 prefix14_class=14042
mov S1, P0
cmp S1, P3
cmovg P0, P3
cmovge P3, S1
cmp P1, P2
cmovg S2, P1
cmovg P1, P2
cmovg P2, S2
mov S1, P3
cmp P2, P3
cmovle P3, P2
cmovl P2, S1
cmovle S1, P3
cmp P0, P1
