# n=5 model=out iset=I1 prefix14_class=5940
mov S0, P2
cmp P2, P0
cmovl S0, P0
cmovge P2, P0
cmp P3, P1
cmovge S2, P1
cmovle S2, P3
cmovle P3, P1
cmovge P1, P3
cmp P1, S0
cmovg P3, S0
cmovle P1, S0
cmp S2, P2
cmovge P0, S2
