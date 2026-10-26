# n=5 model=out iset=I1 prefix14_class=10440
cmp P3, P0
cmovge S2, P0
cmovge P0, P3
cmovl S2, P3
cmp P2, P1
mov S0, P1
cmovg P1, P2
cmovl S0, P2
cmp P1, P0
cmovle P2, P1
cmovg P2, P0
cmovle P1, P0
cmp S0, S2
cmovle P0, S2
