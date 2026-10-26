# n=5 model=out iset=I1 prefix14_class=79
mov S2, P0
cmp P1, P3
mov S0, P3
cmovg S0, P1
cmovge P1, P3
cmp P2, S2
cmovge S2, P2
cmovge P2, P0
cmovl P0, P2
cmp P0, P1
cmovge P0, P1
mov S1, S2
cmovg P1, P2
cmp S1, S0
