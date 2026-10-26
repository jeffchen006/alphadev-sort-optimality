# n=5 model=out iset=I1 prefix14_class=1383
cmp P3, P2
mov S0, P2
cmovl S0, P3
cmovge P2, P3
mov S1, P1
mov P3, P2
cmp S1, P0
cmovge S1, P0
cmovge P0, P1
cmp P0, P2
cmovle P3, P0
cmovg P2, P0
mov P2, S0
cmp S0, S1
