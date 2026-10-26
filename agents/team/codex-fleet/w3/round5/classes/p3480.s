# n=5 model=out iset=I1 prefix14_class=3480
mov S1, P2
cmp P1, S1
cmovg S1, P1
mov S2, P0
cmovge P1, P2
cmp S2, P3
cmovl P0, P3
cmovl P3, S2
mov P2, P1
cmp P3, P2
cmovge P2, P3
cmovg P3, P1
mov P3, P0
cmp P0, S1
