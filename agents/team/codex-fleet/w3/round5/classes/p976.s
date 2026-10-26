# n=5 model=out iset=I1 prefix14_class=976
cmp P0, P1
mov S2, P2
mov S0, P1
cmovl P1, P0
cmovge S0, P0
cmp P2, P3
mov S1, P1
cmovg S2, P3
cmovge P3, P2
cmp S0, P3
mov P0, P3
cmovge P3, S0
cmovg S0, P0
cmp S2, S1
