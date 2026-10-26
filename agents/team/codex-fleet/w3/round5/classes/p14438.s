# n=5 model=out iset=I1 prefix14_class=14438
mov S2, P3
mov S0, P0
cmp P0, P1
cmovge P0, P1
cmovl S0, P1
cmp P2, P3
cmovge P3, P2
cmovl S2, P2
cmp S2, P0
mov P1, S0
cmovge S1, S2
cmovg S2, P0
cmovge P0, S1
mov S2, P0
