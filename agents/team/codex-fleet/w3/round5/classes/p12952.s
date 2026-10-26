# n=5 model=out iset=I1 prefix14_class=12952
cmp P1, P2
mov S1, P0
cmovg S2, P2
cmovg P2, P1
cmovg P1, S2
cmp P3, P0
cmovg S1, P3
cmovl P0, P3
mov S0, P0
cmp P1, S0
cmovg S0, P1
cmovge P1, P0
cmp P2, S1
cmovge P0, P2
