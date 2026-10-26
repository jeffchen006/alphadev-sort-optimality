# n=5 model=out iset=I1 prefix14_class=7798
cmp P3, P2
cmovge S0, P2
cmovl S0, P3
cmovle P3, P2
cmp P1, P0
cmovge P2, P1
cmovge P1, P0
cmovg P0, P2
mov S2, S0
mov S1, P3
cmp P1, S0
cmovl S0, P1
cmovge S2, P1
cmp S1, P0
