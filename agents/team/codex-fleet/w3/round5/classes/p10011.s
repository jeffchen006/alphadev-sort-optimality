# n=5 model=out iset=I1 prefix14_class=10011
cmp P0, P3
cmovge S1, P3
cmovl S1, P0
cmovge P3, P0
cmp P1, P2
cmovge P0, P2
mov S0, S1
cmovg P2, P1
mov S2, P2
cmovge P1, P0
cmp P2, P3
cmovle P2, P3
cmovle P3, S2
cmp S1, P1
