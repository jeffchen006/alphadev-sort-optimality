# n=5 model=out iset=I1 prefix14_class=3560
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
mov S0, P3
cmovle P2, S1
cmp P0, S0
cmovl S0, P0
cmovg P3, P0
cmp S0, P2
cmovge S1, S0
cmovge S0, P2
cmovge P2, S1
mov S2, P1
cmp P3, S2
