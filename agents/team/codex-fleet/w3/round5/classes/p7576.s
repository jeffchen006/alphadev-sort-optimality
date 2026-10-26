# n=5 model=out iset=I1 prefix14_class=7576
cmp P1, P2
mov S0, P2
cmovge P2, P1
mov S1, P3
cmovl S0, P1
cmp S1, P0
cmovl S1, P0
cmovg P3, P0
cmp P3, S0
cmovle P0, P3
cmovle P3, S0
cmovle S0, P0
cmp S1, P2
cmovl S2, S1
