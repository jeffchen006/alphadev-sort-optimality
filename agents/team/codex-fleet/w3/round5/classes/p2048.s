# n=5 model=out iset=I1 prefix14_class=2048
cmp P2, P0
mov S1, P0
cmovl S1, P2
cmovge P0, P2
cmp P3, P1
mov S0, P3
cmovge P3, P1
cmovge P1, S0
mov S2, P1
cmp P1, P0
cmovl P1, P0
cmovg S2, P0
cmp S1, P3
cmovge P2, S1
