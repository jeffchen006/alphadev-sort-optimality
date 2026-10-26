# n=5 model=out iset=I1 prefix14_class=6696
mov S2, P2
mov S0, P1
cmp P3, S0
cmovl S0, P3
cmovle P3, P1
cmp P0, S2
cmovl S2, P0
cmovge P2, P0
cmp P3, P2
cmovg P1, P2
cmovge P2, P3
cmovle P1, P3
cmp S2, S0
cmovge S1, S2
