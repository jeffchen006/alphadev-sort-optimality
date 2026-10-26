# n=5 model=out iset=I1 prefix14_class=3823
mov S2, P1
cmp P1, P0
cmovg S2, P0
cmovg P0, P1
cmp P2, P3
cmovle P1, P3
cmovl P3, P2
cmovge P1, P2
cmp P3, S2
cmovle P2, S2
cmovge P2, P3
cmovl S2, P3
cmp P1, P0
cmovle P3, P0
