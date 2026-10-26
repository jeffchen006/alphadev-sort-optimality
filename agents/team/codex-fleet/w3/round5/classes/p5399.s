# n=5 model=out iset=I1 prefix14_class=5399
cmp P3, P2
mov S0, P1
cmovle S2, P2
cmovge S2, P3
cmovge P3, P2
cmp S0, P0
cmovl S0, P0
cmovle P0, P1
cmp P0, P3
cmovge P1, P0
cmovg P0, P3
mov S1, S2
cmovg P3, P1
cmp S0, S2
