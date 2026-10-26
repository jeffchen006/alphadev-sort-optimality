# n=5 model=out iset=I1 prefix14_class=6001
mov S1, P0
mov S2, P3
cmp P3, P2
cmovge S2, P2
mov S0, S2
cmovle P3, P2
cmp P1, S1
cmovl S1, P1
cmovge P0, P1
cmp P3, P0
cmovge P2, P0
cmovg P0, P3
cmovge P3, P2
cmp S1, S2
