# n=5 model=out iset=I1 prefix14_class=2198
cmp P0, P3
mov S0, P1
mov S1, P0
cmovg P0, P3
cmovle S1, P3
cmp P2, S0
cmovg P1, P2
cmovge P2, S0
mov S2, S1
cmp S1, P1
cmovl S1, P1
cmovle P1, S2
cmp P2, P0
cmovge S2, P0
