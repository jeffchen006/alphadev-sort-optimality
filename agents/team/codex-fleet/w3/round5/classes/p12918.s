# n=5 model=out iset=I1 prefix14_class=12918
cmp P1, P2
cmovl S1, P1
cmovge S1, P2
cmovge P2, P1
cmp P3, P0
cmovl S0, P0
cmovle P0, P3
cmovge S0, P3
cmp S1, P0
cmovge S2, P0
cmovg P0, S1
cmovge S1, S2
mov P3, P2
cmp S0, P2
