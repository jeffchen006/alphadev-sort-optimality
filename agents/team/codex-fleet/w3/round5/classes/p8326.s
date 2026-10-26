# n=5 model=out iset=I1 prefix14_class=8326
cmp P0, P3
cmovl S0, P3
cmovle P3, P0
mov S1, P3
cmovge S0, P0
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmovge P2, S2
cmp S1, P2
cmovge P3, P2
cmovg P2, S1
mov S1, P1
cmp P1, S0
