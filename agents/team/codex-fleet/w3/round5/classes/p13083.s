# n=5 model=out iset=I1 prefix14_class=13083
mov S2, P3
cmp P3, P2
cmovl S2, P2
cmovge P3, P2
mov S1, P3
cmp P0, P1
cmovle P2, P0
cmovl P0, P1
cmovl P1, P2
cmp P1, P3
cmovl P3, P1
cmovg S1, P1
cmp P0, S2
cmovle P2, P0
