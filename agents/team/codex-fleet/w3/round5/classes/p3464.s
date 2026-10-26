# n=5 model=out iset=I1 prefix14_class=3464
mov S0, P3
mov S1, P1
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
cmp P3, P2
cmovge S0, P2
cmovl P3, P2
cmp P0, S0
mov S2, P3
cmovg P1, S0
cmovge S0, P0
cmovg P0, P1
cmp S1, P3
