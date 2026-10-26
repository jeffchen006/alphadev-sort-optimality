# n=5 model=out iset=I1 prefix14_class=1636
mov S0, P2
cmp P2, P0
mov S2, P1
cmovge P2, P0
cmovl S0, P0
cmp P3, S2
cmovl S2, P3
cmovge P1, P3
cmp P2, S2
mov S1, P2
cmovle P2, S2
cmovge S1, S2
cmp S0, P1
mov S1, S0
