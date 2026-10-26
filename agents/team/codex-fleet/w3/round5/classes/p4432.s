# n=5 model=out iset=I1 prefix14_class=4432
cmp P3, P2
cmovge S2, P2
cmovge P2, P3
cmovge P3, S2
mov S0, P0
cmp P0, P1
cmovg S0, P1
cmovl P0, P1
cmp P0, P2
mov P1, P0
cmovl P0, P2
cmovge P1, P2
cmp P3, S0
cmovge P0, P3
