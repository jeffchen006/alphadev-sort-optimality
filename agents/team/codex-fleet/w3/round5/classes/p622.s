# n=5 model=out iset=I1 prefix14_class=622
mov S0, P0
mov S1, P3
cmp P1, S1
cmovge S1, P1
cmovge P1, P3
cmp P0, P2
cmovg S0, P2
cmovg P2, P0
mov S2, S1
cmp P2, S1
cmovge S1, P2
cmovl S2, P2
cmp S0, P1
cmovge P0, P1
