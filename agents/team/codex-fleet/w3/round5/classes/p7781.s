# n=5 model=out iset=I1 prefix14_class=7781
mov S1, P0
cmp S1, P1
mov S2, P3
cmovg S1, P1
cmovl P0, P1
cmp S2, P2
cmovl P3, P2
cmovge S2, P2
cmp S1, S2
cmovge P2, S2
cmovge S2, S1
cmovg S1, P2
cmp P0, P3
mov S0, P3
