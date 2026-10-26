# n=5 model=out iset=I1 prefix14_class=8125
mov S1, P3
cmp P2, S1
cmovle P3, P2
cmovle P2, S1
cmp P0, P1
mov S1, P3
cmovl S2, P1
cmovle P1, P0
cmovl P0, S2
cmp P3, P1
cmovg S1, P1
cmovle P3, P1
cmp P2, P0
cmovge P1, P2
