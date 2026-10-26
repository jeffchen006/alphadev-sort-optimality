# n=5 model=out iset=I1 prefix14_class=2803
mov S2, P0
cmp P1, P3
mov S1, P1
cmovg P1, P3
cmovg P3, S1
cmp P2, S2
cmovl S2, P2
cmovl P2, P0
cmp P2, P3
cmovge P0, P3
cmovge P3, P2
mov S1, S2
cmovg P2, P0
mov S0, P2
