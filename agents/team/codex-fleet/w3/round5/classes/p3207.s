# n=5 model=out iset=I1 prefix14_class=3207
mov S1, P3
cmp P0, S1
cmovl P3, P0
cmovg S1, P0
cmp P2, P1
mov S0, P1
cmovg P1, P2
cmovge P2, S0
mov S0, P2
cmp P3, S0
cmovg P2, P3
cmovg P3, S0
cmp S1, P1
cmovge S2, S1
