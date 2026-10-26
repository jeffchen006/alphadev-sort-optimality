# n=5 model=out iset=I1 prefix14_class=5772
cmp P1, P0
mov S2, P3
cmovge S1, P0
cmovg P0, P1
cmovg P1, S1
cmp P2, P3
mov S0, P1
cmovl P3, P2
cmovg S2, P2
cmp P3, S0
cmovl S0, P3
cmovge P1, P3
cmp P0, S2
mov S0, P0
