# n=5 model=out iset=I1 prefix14_class=9112
mov S0, P0
cmp P0, P1
cmovl S0, P1
cmovge P0, P1
mov S2, P0
cmp P3, P2
mov S1, P3
cmovg P3, P2
cmovge P2, S1
cmp P3, P0
cmovg S2, P3
cmovl P0, P3
cmp P2, S0
cmovg S1, P2
