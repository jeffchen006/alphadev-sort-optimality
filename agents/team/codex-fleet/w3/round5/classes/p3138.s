# n=5 model=out iset=I1 prefix14_class=3138
mov S2, P2
mov S0, P3
cmp P1, P3
cmovg P3, P1
cmovl S0, P1
mov S1, S0
cmp P0, S2
cmovge S2, P0
cmovle P2, P0
cmp S1, P2
cmovge S1, P2
cmovle S0, P2
cmp S2, P3
cmovg P0, P3
