# n=5 model=out iset=I1 prefix14_class=10421
cmp P1, P0
mov S0, P1
cmovl P1, P0
cmovg S0, P0
mov S2, P3
cmp P2, P3
cmovl S2, P2
cmovge P3, P2
cmp P1, P3
cmovge P2, P1
cmovge P1, P3
cmovge P3, P2
mov P0, S2
cmp S0, P0
