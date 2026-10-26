# n=5 model=out iset=I1 prefix14_class=8607
cmp P0, P3
mov S1, P3
cmovl P3, P0
cmovge S1, P0
cmp P2, P1
cmovge S0, P1
cmovge P1, P2
mov S2, S1
mov P0, P3
cmovge P2, S0
cmp S2, P1
cmovg S2, P1
cmovge P1, S1
cmp P0, P2
