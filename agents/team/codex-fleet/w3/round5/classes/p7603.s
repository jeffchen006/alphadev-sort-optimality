# n=5 model=out iset=I1 prefix14_class=7603
cmp P2, P0
cmovl S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P3, P1
mov S2, P1
cmovge P1, P3
cmovge P3, S2
cmovl S2, P3
cmp P0, P3
cmovg S2, P0
cmovle P3, P0
cmp P1, P2
mov P3, S2
