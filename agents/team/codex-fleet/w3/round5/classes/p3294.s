# n=5 model=out iset=I1 prefix14_class=3294
cmp P1, P0
mov S1, P1
mov S0, P2
cmovl S1, P0
cmovge P1, P0
cmovl P0, P1
cmp P3, P2
cmovg S0, P3
cmovge P3, P2
cmp P1, P3
mov S2, S1
cmovg P0, P3
cmovge P3, P1
mov P1, P3
