# n=5 model=out iset=I1 prefix14_class=7786
mov S2, P3
cmp P1, P3
cmovg S2, P1
cmovge P1, P3
cmp P2, P0
cmovl S0, P2
cmovge S0, P0
cmovl P2, P0
cmp P1, S0
cmovg P3, S0
cmovg S0, P1
cmovg P1, P3
mov P1, P2
cmp P1, S2
