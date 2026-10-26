# n=5 model=out iset=I1 prefix14_class=5616
mov S2, P2
cmp P1, P0
mov S1, P1
cmovle P1, P0
cmovg S1, P0
cmp P2, P3
cmovle P2, P3
mov P0, S1
cmovle P3, S2
cmp P0, P3
cmovg S1, P3
cmovge P3, P0
cmp P2, P1
cmovl P0, P2
