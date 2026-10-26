# n=5 model=out iset=I1 prefix14_class=6421
cmp P2, P1
mov S1, P2
cmovge P2, P1
cmovge P1, S1
cmp P3, P0
mov S1, P0
cmovle P0, P3
cmovge S1, P3
mov P3, S1
cmp P1, P3
cmovl P3, P1
cmovg S1, P1
cmp P0, P2
cmovle P1, P3
