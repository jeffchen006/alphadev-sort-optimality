# n=5 model=out iset=I1 prefix14_class=13644
cmp P1, P3
mov S2, P3
cmovl S2, P1
cmovg P3, P1
mov S0, P0
cmp S0, P2
cmovge S0, P2
cmovle P0, P2
cmp S2, S0
cmovge P2, S0
cmovge S0, S2
cmovge S2, P2
mov S1, S0
cmp P0, P3
