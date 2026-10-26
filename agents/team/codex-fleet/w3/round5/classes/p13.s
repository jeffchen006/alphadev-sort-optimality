# n=5 model=out iset=I1 prefix14_class=13
mov S1, P3
cmp P0, S1
cmovle S1, P0
cmovle P0, P3
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmovge P2, S2
mov S2, P2
cmp S1, P1
cmovge S0, S1
cmovge S1, P1
cmovl S0, P1
cmp P2, P0
