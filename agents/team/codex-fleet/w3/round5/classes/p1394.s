# n=5 model=out iset=I1 prefix14_class=1394
mov S1, P2
cmp P3, P2
cmovge P2, P3
cmovl S1, P3
mov S0, P0
cmp P0, P1
mov P3, P2
cmovg P0, P1
cmovge P1, S0
cmp P1, P3
cmovl P3, P1
cmovl P1, P2
mov P1, P0
cmovl P2, P3
