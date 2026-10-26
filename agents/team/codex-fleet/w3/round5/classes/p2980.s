# n=5 model=out iset=I1 prefix14_class=2980
mov S2, P3
mov S1, P0
cmp P2, P0
cmovg S1, P2
cmovl P0, P2
cmp P3, P1
cmovge P3, P1
mov P2, S1
cmovge P1, S2
cmp P1, S1
cmovge S1, P1
cmovl P2, P1
cmp P3, P0
mov S1, P2
