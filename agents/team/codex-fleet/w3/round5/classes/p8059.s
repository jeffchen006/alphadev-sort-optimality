# n=5 model=out iset=I1 prefix14_class=8059
mov S0, P2
cmp P3, P2
cmovle P2, P3
cmovle P3, S0
cmp P0, P1
cmovge S0, P0
cmovg P0, P1
cmovg P1, S0
mov S2, P0
cmp P0, P2
cmovl S2, P2
mov S1, P1
cmovge P0, P2
cmp S1, P3
