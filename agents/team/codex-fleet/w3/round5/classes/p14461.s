# n=5 model=out iset=I1 prefix14_class=14461
mov S0, P3
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmovg P0, S1
cmp S0, P1
mov S2, P0
cmovl S0, P1
cmovle P1, P3
cmp P1, P2
cmovge P3, P1
cmovg P1, P2
cmovge P2, P3
cmp S2, S0
