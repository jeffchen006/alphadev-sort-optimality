# n=5 model=out iset=I1 prefix14_class=1270
cmp P2, P0
mov S2, P2
cmovge P2, P0
mov S0, P3
cmovl S2, P0
cmp S0, P1
cmovl S0, P1
cmovle P1, P3
mov P0, S2
cmp P0, S0
cmovge P0, S0
cmovl S2, S0
cmp P2, P1
mov S0, P2
