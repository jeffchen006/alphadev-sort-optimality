# n=5 model=out iset=I1 prefix14_class=2862
cmp P3, P2
mov S1, P2
cmovg S1, P3
cmovl P2, P3
mov P3, P1
cmp P0, P1
cmovg P1, P0
cmovge P0, P3
cmp P1, S1
mov S2, S1
cmovg S2, P1
cmovge P1, S1
cmp P0, P2
mov S0, P1
