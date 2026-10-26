# n=5 model=out iset=I1 prefix14_class=9129
mov S0, P2
cmp P2, P3
cmovg S0, P3
cmovl P2, P3
cmp P1, P0
cmovg S1, P1
mov S2, P2
mov P3, S0
cmovge P1, P0
cmovg P0, S1
cmp P1, P3
cmovl S0, P1
cmovg P3, P1
cmp P0, P2
