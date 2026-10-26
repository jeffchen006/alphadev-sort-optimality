# n=5 model=out iset=I1 prefix14_class=8791
cmp P2, P0
mov S0, P3
mov S2, P2
cmovge S2, P0
cmovle P2, P0
cmp P1, P3
cmovl S0, P1
cmovg P3, P1
cmp P2, P3
cmovge P0, P2
cmovge P2, P3
mov S1, S2
cmovge P3, P0
cmp S1, S0
