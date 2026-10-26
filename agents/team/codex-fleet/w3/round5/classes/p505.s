# n=5 model=out iset=I1 prefix14_class=505
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
mov S0, P1
cmovl S1, P3
cmp S0, P2
cmovge P1, P2
cmovg P2, S0
mov S2, S1
cmp P1, S1
cmovl S1, P1
cmovle P1, S2
cmp P0, P2
cmovge S2, P0
