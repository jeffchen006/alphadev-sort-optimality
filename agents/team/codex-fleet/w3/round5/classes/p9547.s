# n=5 model=out iset=I1 prefix14_class=9547
cmp P1, P2
cmovge S0, P2
cmovge P2, P1
cmovge P1, S0
mov S2, P0
cmp P0, P3
cmovge P0, P3
cmovl S2, P3
mov S1, P0
cmp P0, P1
cmovle P0, P1
cmovge S1, P1
mov P3, P2
cmp S2, P2
