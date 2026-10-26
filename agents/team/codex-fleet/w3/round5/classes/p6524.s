# n=5 model=out iset=I1 prefix14_class=6524
mov S1, P1
cmp P1, P2
cmovg P1, P2
cmovge P2, S1
cmp P3, P0
cmovl S1, P0
mov S2, P1
cmovle P0, P3
cmovl P3, S1
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
cmp P0, P1
