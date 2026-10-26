# n=5 model=out iset=I1 prefix14_class=1656
cmp P0, P3
mov S1, P1
cmovg S2, P3
cmovge P3, P0
cmovg P0, S2
cmp S1, P2
cmovg S1, P2
cmovge P2, P1
mov S0, P0
cmp P0, S1
cmovl P0, S1
cmovl S1, S0
cmp P3, P2
cmovge S0, P3
