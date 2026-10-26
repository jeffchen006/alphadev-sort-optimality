# n=5 model=out iset=I1 prefix14_class=9603
mov S2, P1
cmp P2, S2
mov S1, P3
cmovl S2, P2
cmovge P1, P2
mov S0, P1
cmp P0, S1
cmovge P3, P0
cmovge P0, S1
cmp S0, P3
cmovg S0, P3
cmovge P3, P1
cmp S2, P0
cmovge P2, P0
