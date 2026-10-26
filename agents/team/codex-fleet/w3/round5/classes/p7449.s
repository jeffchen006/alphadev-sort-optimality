# n=5 model=out iset=I1 prefix14_class=7449
cmp P0, P2
cmovge S2, P0
mov S1, P3
cmovg P0, P2
cmovg P2, S2
cmp P3, P1
cmovl P3, P1
cmovg S1, P1
cmovl P1, S1
cmp P0, P1
cmovl P1, P0
cmovg S1, P0
cmp P3, P2
cmovge P1, P3
