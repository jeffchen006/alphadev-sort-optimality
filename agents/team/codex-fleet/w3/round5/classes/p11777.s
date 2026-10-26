# n=5 model=out iset=I1 prefix14_class=11777
cmp P3, P0
mov S0, P0
cmovge P0, P3
cmovg P3, S0
mov S1, P2
cmp P1, P2
cmovg S1, P1
cmovl P2, P1
cmp P0, S1
cmovge S2, S1
cmovg S1, P0
cmovge P0, S2
mov S1, P3
cmp P2, P3
