# n=5 model=out iset=I1 prefix14_class=3442
cmp P3, P2
cmovge S2, P2
cmovge P2, P3
cmovge P3, S2
mov S0, P0
cmp P0, P1
cmovg S0, P1
cmovl P0, P1
mov P1, S0
cmp P3, S0
cmovg P1, P3
cmovge P3, S0
mov P3, P2
cmp P0, P2
