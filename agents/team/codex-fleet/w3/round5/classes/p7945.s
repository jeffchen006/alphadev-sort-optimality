# n=5 model=out iset=I1 prefix14_class=7945
mov S2, P2
cmp P2, P0
cmovg P2, P0
cmovl S2, P0
cmovge P0, S2
mov S0, P1
cmp S0, P3
cmovg S0, P3
cmovg P3, P1
cmp P2, S0
cmovge P1, S0
cmovge S0, P2
mov S1, S0
cmovge P2, P1
