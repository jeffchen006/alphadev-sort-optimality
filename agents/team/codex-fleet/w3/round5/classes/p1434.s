# n=5 model=out iset=I1 prefix14_class=1434
mov S2, P0
mov S0, P3
cmp P0, P1
cmovg S2, P1
cmovge P1, P0
cmp P2, P3
cmovg P3, P2
cmovg P2, S0
mov S0, P3
cmp P3, P1
cmovg S0, P1
cmovl P3, P1
cmp S2, P2
cmovge P0, P2
