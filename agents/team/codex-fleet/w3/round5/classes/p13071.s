# n=5 model=out iset=I1 prefix14_class=13071
cmp P3, P0
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P1, P2
mov S1, P1
cmovl P1, P2
cmovge S1, P2
cmp S1, P3
cmovg S0, S1
cmovg S1, P3
cmovg P3, S0
cmp P0, P1
cmovge S0, P1
