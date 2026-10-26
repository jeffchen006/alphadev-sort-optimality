# n=5 model=out iset=I1 prefix14_class=7820
mov S1, P1
cmp P1, P3
cmovge S1, P3
mov S0, P0
cmovge P3, P1
cmp P2, P0
cmovl S0, P2
cmovg P0, P2
mov S2, S0
cmp S2, S1
cmovg S2, S1
cmovg S1, S0
mov S0, S1
cmp P0, P3
