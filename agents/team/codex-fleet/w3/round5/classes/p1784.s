# n=5 model=out iset=I1 prefix14_class=1784
mov S2, P1
cmp P0, P1
cmovg P1, P0
cmovg P0, S2
mov S0, P1
cmp P2, P3
cmovl S1, P3
cmovge S1, P2
cmovge P2, P3
cmp S0, S1
cmovl S0, S1
cmovge P1, S1
cmp P0, P2
cmovge P3, P2
