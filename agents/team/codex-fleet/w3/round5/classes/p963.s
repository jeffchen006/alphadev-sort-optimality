# n=5 model=out iset=I1 prefix14_class=963
cmp P0, P2
cmovl S0, P2
cmovge S0, P0
cmovl P2, P0
cmp P1, P3
cmovg P0, P1
mov S1, S0
cmovg P1, P3
cmovg P3, P0
cmp P3, S0
cmovg S0, P3
cmovge P3, S1
cmp P1, P2
cmovg S1, P2
