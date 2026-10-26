# n=5 model=out iset=I1 prefix14_class=9727
cmp P3, P1
mov S0, P0
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
cmp S0, P2
cmovle P0, P2
cmovle P2, S0
cmp P0, P1
cmovge S1, P1
cmovl S1, P0
cmovle P0, P1
cmp P3, P2
cmovl S2, P3
