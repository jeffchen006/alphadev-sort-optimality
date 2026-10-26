# n=5 model=out iset=I1 prefix14_class=5807
mov S1, P0
mov S2, P3
cmp P1, P3
cmovl S2, P1
cmovge P3, P1
cmp P0, P2
cmovge S1, P2
mov S0, S1
cmovge P2, P0
cmp S2, S0
cmovge S1, S2
cmovg S2, S0
mov S2, P2
cmp P3, S2
