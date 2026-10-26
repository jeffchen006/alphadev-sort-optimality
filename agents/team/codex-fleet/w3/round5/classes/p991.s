# n=5 model=out iset=I1 prefix14_class=991
mov S2, P0
cmp P1, S2
cmovl P0, P1
cmovge S2, P1
mov S0, P3
mov S1, P0
cmp P3, P2
cmovg P3, P2
cmovg P2, S0
cmp S2, P2
cmovge P1, P2
cmovge P2, S2
cmovg S2, P1
cmp P3, S1
