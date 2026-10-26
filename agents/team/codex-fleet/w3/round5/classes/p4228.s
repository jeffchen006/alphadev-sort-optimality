# n=5 model=out iset=I1 prefix14_class=4228
cmp P1, P0
mov S1, P0
cmovg S1, P1
cmovge P1, P0
mov S0, P2
cmp P3, P2
cmovge S0, P3
cmovg P3, P2
cmp P3, P1
mov S2, P1
cmovge S2, P3
cmovl P1, P3
cmp S0, S1
cmovge P0, S0
