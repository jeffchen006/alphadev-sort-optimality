# n=5 model=out iset=I1 prefix14_class=12951
cmp P1, P2
mov S2, P0
cmovg S0, P2
cmovg P2, P1
cmovg P1, S0
cmp P3, P0
cmovl P0, P3
cmovg S2, P3
mov S1, P0
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmp P2, S2
mov P3, S1
