# n=5 model=out iset=I1 prefix14_class=546
mov S0, P3
cmp P2, S0
cmovl S0, P2
cmovg P3, P2
mov S1, P0
cmp S1, P1
cmovge S1, P1
cmovge P1, P0
mov P0, S0
cmp S1, S0
cmovge P0, S1
cmovg S1, S0
mov S2, P3
cmp P1, S2
