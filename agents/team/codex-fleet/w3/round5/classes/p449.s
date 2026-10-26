# n=5 model=out iset=I1 prefix14_class=449
cmp P1, P2
mov S2, P2
cmovle P2, P1
cmovg S2, P1
cmp P3, P0
mov S1, P3
cmovge P3, P0
mov P1, P2
cmovge P0, S1
cmp P3, P2
cmovl P1, P3
mov P1, P0
cmovl P3, P2
cmp P1, S2
