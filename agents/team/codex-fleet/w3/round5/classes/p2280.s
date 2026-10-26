# n=5 model=out iset=I1 prefix14_class=2280
cmp P3, P2
mov S1, P3
cmovg S1, P2
mov S2, P1
cmovl P3, P2
cmp P1, P0
cmovle S2, P0
cmovge P1, P0
cmp P3, S2
cmovg P2, P3
cmovle P2, S2
cmovl S2, P3
cmp S1, P1
cmovle P2, P1
