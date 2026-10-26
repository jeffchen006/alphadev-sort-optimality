# n=5 model=out iset=I1 prefix14_class=6832
cmp P1, P3
cmovl S2, P3
cmovl P3, P1
cmovl P1, S2
cmp P0, P2
mov S2, P0
cmovg S2, P2
cmovle P0, P2
cmovge P2, P0
cmp P1, P0
cmovl P0, P1
cmovle P1, P2
mov P1, S2
cmp P3, S2
