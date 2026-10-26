# n=5 model=out iset=I1 prefix14_class=1206
mov S0, P1
cmp P1, P2
cmovle P1, P2
cmovle P2, S0
cmp P0, P3
cmovge S2, P0
mov S0, P1
cmovge P0, P3
cmovl S2, P3
cmp S0, S2
cmovge P1, S2
cmovge S2, S0
cmp P2, P0
mov S0, P1
