# n=5 model=out iset=I1 prefix14_class=9605
mov S1, P3
cmp P0, P2
mov S2, P2
cmovge P2, P0
cmovl S2, P0
cmp P1, P3
mov P0, P2
cmovg P3, P1
cmovg P1, S1
cmp P2, P3
cmovg P2, P3
cmovge P3, P0
cmp P1, S2
cmovl P3, P1
