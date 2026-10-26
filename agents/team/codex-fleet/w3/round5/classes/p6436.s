# n=5 model=out iset=I1 prefix14_class=6436
cmp P1, P3
mov S2, P3
mov S1, P2
cmovl S2, P1
cmovg P3, P1
cmp P0, S1
cmovl S1, P0
cmovg P2, P0
mov S0, P2
cmp P3, S0
cmovl P2, P3
cmovg S0, P3
cmp S1, S2
cmovge P3, S1
