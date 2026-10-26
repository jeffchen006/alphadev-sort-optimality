# n=5 model=out iset=I1 prefix14_class=9411
mov S0, P0
cmp P3, S0
cmovge P0, P3
mov S2, P1
cmovg P3, S0
cmp P2, P1
cmovl S2, P2
cmovl P2, P1
cmp P3, S2
cmovge S1, P3
cmovg P3, S2
cmovg S2, S1
cmp P0, P2
mov S0, P2
