# n=5 model=out iset=I1 prefix14_class=7450
cmp P0, P1
cmovge S2, P0
mov S1, P3
cmovg P0, P1
cmovg P1, S2
cmp P3, P2
cmovl P3, P2
cmovg S1, P2
mov P2, S1
cmp P0, P2
cmovl P2, P0
cmovg S1, P0
cmp P3, P1
cmovge P2, P3
