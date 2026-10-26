# n=5 model=out iset=I1 prefix14_class=7088
cmp P1, P2
mov S2, P2
mov S0, P0
cmovg S2, P1
cmovg P1, P2
cmp P0, P3
cmovge P0, P3
cmovge P3, S0
cmp P0, P1
mov S1, P1
cmovge P1, P0
cmovl S1, P0
cmp P3, S2
cmovl P2, S2
