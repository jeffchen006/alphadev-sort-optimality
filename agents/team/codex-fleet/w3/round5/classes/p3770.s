# n=5 model=out iset=I1 prefix14_class=3770
mov S2, P3
mov S0, P1
cmp P0, S0
cmovg P1, P0
cmovl S0, P0
cmp P2, S2
cmovge S2, P2
mov S1, S0
cmovge P2, P3
cmp S0, P2
cmovl S0, P2
cmovle P2, S1
cmp P1, S2
cmovl P2, P1
