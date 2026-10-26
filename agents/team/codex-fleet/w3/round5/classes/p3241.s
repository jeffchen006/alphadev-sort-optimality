# n=5 model=out iset=I1 prefix14_class=3241
mov S1, P3
cmp P1, P0
mov S0, P0
cmovg P0, P1
cmovge P1, S0
cmp P2, P3
cmovg S1, P2
cmovg P2, P3
mov P3, P1
cmp P3, P2
cmovl P3, P2
cmovg P1, P2
cmp P0, S1
cmovge S0, S1
