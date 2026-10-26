# n=5 model=out iset=I1 prefix14_class=11604
cmp P3, P1
cmovg S1, P3
cmovg P3, P1
mov S2, P0
cmovg P1, S1
cmp S2, P2
cmovl P0, P2
cmovl P2, S2
mov S0, P1
cmp S0, P0
cmovge S0, P0
mov S2, P2
cmovge P0, P1
cmp P3, P2
