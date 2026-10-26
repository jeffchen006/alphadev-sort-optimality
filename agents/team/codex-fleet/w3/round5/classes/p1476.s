# n=5 model=out iset=I1 prefix14_class=1476
mov S1, P0
mov S0, P3
cmp S0, P2
cmovl S0, P2
cmovg P3, P2
cmovge P2, S0
cmp P0, P1
cmovl S1, P1
cmovle P1, P0
cmp S1, P2
cmovge S0, S1
cmovge S1, P2
mov S0, P3
cmp P1, P3
