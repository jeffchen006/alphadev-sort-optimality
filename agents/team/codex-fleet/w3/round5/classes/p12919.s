# n=5 model=out iset=I1 prefix14_class=12919
cmp P1, P2
cmovge S1, P2
cmovl S1, P1
cmovge P2, P1
cmp P3, P0
mov S0, P0
cmovle P0, P3
cmovge S0, P3
cmp P0, S1
cmovge S2, S1
cmovge S1, P0
mov P3, P2
cmovg P0, S2
cmp S0, P3
