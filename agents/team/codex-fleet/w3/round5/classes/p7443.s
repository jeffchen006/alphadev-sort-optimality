# n=5 model=out iset=I1 prefix14_class=7443
cmp P2, P0
cmovge S0, P2
mov S1, P1
cmovge P2, P0
mov S2, P2
cmovl S0, P0
cmp P1, P3
cmovge P1, P3
cmovg P3, S1
cmp S2, P1
cmovle P0, S0
cmovge S2, P1
cmovge P1, P2
cmp P3, S0
