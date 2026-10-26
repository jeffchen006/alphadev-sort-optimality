# n=5 model=out iset=I1 prefix14_class=12837
mov S2, P3
cmp P1, S2
cmovge P3, P1
cmovge P1, S2
mov S1, P0
cmp P2, P0
cmovl P0, P2
mov S0, P0
cmovg S1, P2
cmp P1, P0
cmovl P0, P1
mov P0, S1
cmovg S0, P1
mov P1, S0
