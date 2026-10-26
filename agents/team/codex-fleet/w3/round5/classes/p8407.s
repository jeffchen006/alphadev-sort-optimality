# n=5 model=out iset=I1 prefix14_class=8407
cmp P3, P2
mov S2, P3
mov S1, P0
cmovg S2, P2
cmovg P2, P3
cmp P1, P0
cmovge S1, P1
cmovl P0, P1
cmp P2, S1
mov P3, S2
cmovge P1, S1
cmovg S1, P2
cmovg P2, P1
cmp P0, S2
