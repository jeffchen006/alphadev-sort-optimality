# n=5 model=out iset=I1 prefix14_class=6776
mov S1, P2
cmp S1, P1
cmovg S1, P1
cmovl P2, P1
mov S2, S1
mov S0, P3
cmp P0, P3
cmovge S0, P0
cmovge P0, P3
cmp S0, P2
cmovge P3, S0
cmovg S0, P2
cmovg P2, P3
cmp S1, P0
