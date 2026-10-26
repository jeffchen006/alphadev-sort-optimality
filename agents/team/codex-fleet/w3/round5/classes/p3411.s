# n=5 model=out iset=I1 prefix14_class=3411
mov S2, P2
cmp P1, P2
cmovg S2, P1
cmovl P2, P1
cmp P3, P0
mov S1, P3
cmovge P3, P0
cmovl S1, P0
cmovl P0, P3
cmp P2, P3
cmovle P0, P2
mov S0, S2
cmovge P3, P2
mov P0, P3
