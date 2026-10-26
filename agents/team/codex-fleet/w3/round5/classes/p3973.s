# n=5 model=out iset=I1 prefix14_class=3973
mov S1, P2
mov S0, P0
cmp S1, P3
cmovl S1, P3
cmovg P2, P3
cmp P1, P0
cmovge S0, P1
cmovle P0, P1
mov S2, P2
cmp P0, P2
cmovge S2, P0
cmovge P0, P2
cmp S1, S0
mov P0, S0
