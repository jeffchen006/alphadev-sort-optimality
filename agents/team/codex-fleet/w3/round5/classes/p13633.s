# n=5 model=out iset=I1 prefix14_class=13633
cmp P2, P1
cmovl S2, P1
cmovle P1, P2
cmovge S2, P2
mov S0, P0
cmp P0, P3
cmovl S0, P3
cmovge P0, P3
cmp P1, P0
cmovg P2, P0
cmovge P0, P1
cmovg P1, P2
cmp S2, S0
mov P1, S0
