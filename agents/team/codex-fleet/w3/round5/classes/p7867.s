# n=5 model=out iset=I1 prefix14_class=7867
cmp P1, P0
cmovge S2, P1
cmovl S2, P0
cmovl P0, P1
mov S1, P2
cmp P3, S1
cmovge P2, P3
cmovge P3, S1
cmp P3, P0
mov S0, P0
cmovg S0, P3
cmovge P3, P0
cmp P2, S2
cmovge P0, S2
