# n=5 model=out iset=I1 prefix14_class=1205
mov S0, P1
cmp P1, P0
cmovle P1, P0
cmovle P0, S0
cmp P2, P3
cmovge S2, P2
mov S0, P1
cmovge P2, P3
cmovl S2, P3
cmp S0, S2
cmovge P1, S2
cmovge S2, S0
cmp P0, P2
mov S0, P1
