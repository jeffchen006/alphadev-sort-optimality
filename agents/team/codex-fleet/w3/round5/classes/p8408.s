# n=5 model=out iset=I1 prefix14_class=8408
cmp P3, P1
mov S2, P3
mov S1, P0
cmovge S2, P1
cmovg P1, P3
cmp P2, S1
cmovge S1, P2
cmovl P0, P2
cmp P1, S1
mov P3, S2
cmovge P2, S1
cmovg S1, P1
cmovg P1, P2
cmp P0, S2
