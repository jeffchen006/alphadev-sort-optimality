# n=5 model=out iset=I1 prefix14_class=10420
cmp P1, P0
mov S0, P1
cmovl P1, P0
cmovg S0, P0
cmp P3, P2
mov S2, P2
cmovl S2, P3
cmovg P2, P3
cmp P1, P2
cmovge P3, P1
cmovge P1, P2
cmovge P2, P3
mov P2, S2
cmp S0, P2
