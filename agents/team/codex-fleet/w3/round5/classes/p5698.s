# n=5 model=out iset=I1 prefix14_class=5698
cmp P0, P3
mov S2, P0
mov S0, P1
cmovg P0, P3
cmovg P3, S2
cmp S0, P2
cmovge S0, P2
mov S2, P0
cmovge P2, P1
cmp S0, P0
cmovle P0, S0
cmovl S0, S2
cmp P2, P3
cmovle P1, P2
