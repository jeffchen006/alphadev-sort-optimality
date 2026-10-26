# n=5 model=out iset=I1 prefix14_class=8689
mov S2, P2
cmp P1, S2
cmovl S2, P1
mov S0, P3
cmovge P2, P1
cmp S0, P0
cmovg P3, P0
cmovl S0, P0
cmp S0, P2
cmovge S1, S0
cmovl S1, P2
cmovle P2, S0
cmp S2, P3
cmovge S0, S2
