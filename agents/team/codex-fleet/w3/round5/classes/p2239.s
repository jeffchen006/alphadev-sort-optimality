# n=5 model=out iset=I1 prefix14_class=2239
mov S0, P1
cmp P3, P1
cmovg P1, P3
cmovg P3, S0
mov S0, P0
cmp P2, P0
cmovge S0, P2
mov S1, S0
cmovge P2, P0
cmp S1, P1
cmovl S0, P1
cmovle P1, S1
cmp P2, P3
cmovle S2, P2
