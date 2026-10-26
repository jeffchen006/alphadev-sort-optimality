# n=5 model=out iset=I1 prefix14_class=9604
mov S1, P2
cmp P0, P3
mov S2, P3
cmovge P3, P0
cmovl S2, P0
cmp P1, P2
mov P0, P3
cmovg P2, P1
cmovg P1, S1
cmp P3, P2
cmovg P3, P2
cmovge P2, P0
cmp P1, S2
cmovl P2, P1
