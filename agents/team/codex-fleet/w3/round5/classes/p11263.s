# n=5 model=out iset=I1 prefix14_class=11263
cmp P1, P3
mov S0, P3
cmovg S0, P1
cmovge P1, P3
cmp P0, P2
cmovge P3, P2
cmovg P2, P0
cmovg P0, P3
mov S1, P0
cmp P2, S0
mov S2, S0
cmovl S0, P2
cmovge S2, P2
cmovge P2, S0
