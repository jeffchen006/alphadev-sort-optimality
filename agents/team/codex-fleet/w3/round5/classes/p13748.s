# n=5 model=out iset=I1 prefix14_class=13748
cmp P2, P1
mov S2, P2
cmovg P2, P1
cmovl S2, P1
cmp P0, P3
mov S1, P2
mov S0, P3
cmovge S0, P0
cmovge P0, P3
cmp S2, S0
cmovge P1, S2
cmovge S2, S0
cmovg S0, P1
cmp S1, P0
