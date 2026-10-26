# n=5 model=out iset=I1 prefix14_class=10573
mov S0, P1
mov S1, P3
cmp P1, P2
cmovg S0, P2
cmovg P2, P1
cmp P0, P3
cmovg P3, P0
cmovge P0, S1
mov S2, P3
cmp P2, S2
cmovl P3, P2
cmovg S2, P2
cmp S0, P0
cmovl S1, S0
