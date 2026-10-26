# n=5 model=out iset=I1 prefix14_class=7744
mov S0, P2
cmp S0, P3
cmovl S0, P3
cmovle P3, P2
mov S1, P1
cmp P0, S1
cmovg P1, P0
cmovl S1, P0
cmp S1, P3
cmovge S2, S1
cmovge S1, P3
cmovl S2, P3
cmp S0, P1
cmovge P2, P1
