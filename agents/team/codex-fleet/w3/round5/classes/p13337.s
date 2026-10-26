# n=5 model=out iset=I1 prefix14_class=13337
cmp P3, P1
cmovg S0, P3
cmovge P3, P1
cmovg P1, S0
mov S2, P3
cmp P0, P2
cmovl S0, P0
cmovl P0, P2
cmovl P2, S0
cmp P2, S2
cmovl S2, P2
cmovg P3, P2
cmp P1, P0
cmovg S2, P0
