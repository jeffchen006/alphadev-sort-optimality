# n=5 model=out iset=I1 prefix14_class=4644
mov S1, P0
cmp P3, S1
cmovle P0, P3
cmovg S1, P3
cmp P1, P2
cmovl S2, P2
cmovle P2, P1
cmovl P1, S2
cmp P1, S1
mov P3, P1
cmovl P3, S1
cmovge P1, S1
mov P3, P0
cmp P2, P0
